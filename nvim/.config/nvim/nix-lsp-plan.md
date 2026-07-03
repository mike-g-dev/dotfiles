# Native-first LSP/tooling with on-demand Mason fallback

## Context

The nvim config should work seamlessly in and out of Nix dev shells. Tooling
(LSP servers and LSP-related tooling — i.e. conform formatters) should
**default to whatever the shell provides** (Nix via direnv) and only fall back
to Mason when a requested tool is genuinely absent.

Two problems with the current setup:

1. **Mason wins over the shell.** `mason.nvim` defaults to `PATH = "prepend"`,
   putting its bin dir at the front of `$PATH`. Since both nvim-lspconfig and
   conform resolve bare binary names through `$PATH`, Mason's copy shadows the
   Nix one. (Verified: `mason.nvim/lua/mason-core/installer/InstallLocation.lua:92-94`.)

2. **Enablement is implicit.** `mason-lspconfig`'s `automatic_enable` turns a
   server on *because Mason installed it* — the source of truth is "whatever
   Mason happens to have," not an explicit list. (Verified:
   `mason-lspconfig.nvim/lua/mason-lspconfig/features/automatic_enable.lua` — it
   iterates `registry.get_installed_package_names()`.)

**Desired end state:** an explicit list of servers is enabled via the native
nvim 0.11+ `vim.lsp.enable()` API, assuming the tool is installed (Nix shell).
If and only if a requested tool's binary is not on `$PATH` do we fall back to
installing it via Mason, then enable it.

### Decisions

- **Missing tool → auto-install + non-blocking `vim.notify`.** When you open a
  file whose tool isn't on `$PATH`, Mason installs it automatically and shows a
  notification; it never blocks with a y/n confirm.
- **Scope = all LSP + LSP-related tooling currently present**: the LSP servers
  (nvim-lspconfig, driven by the explicit list) **and** the conform formatters.
  Formatters are first-class here, not an optional add-on. (No linters /
  nvim-lint are present, so nothing else is in scope.)
- **Uniform treatment — no special tiers.** Every server, `rust_analyzer`
  included, is native-first with a Mason fallback. There is nothing special
  about `rust_analyzer` in the new setup; the old `project_servers` special-case
  goes away.

## Verified API facts (from installed runtime/plugins)

- `vim.lsp.config[name]` resolves the merged config, incl. `cmd`/`filetypes`,
  from nvim-lspconfig's bundled `lsp/<name>.lua`.
- `vim.lsp.enable(name)` runs `doautoall` (`$VIMRUNTIME/lua/vim/lsp.lua:655`), so
  calling it on an **already-open** buffer starts the server — no manual
  `vim.lsp.start` needed.
- `require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package`
  maps server → Mason package name (`lua_ls` → `lua-language-server`, etc.).
- `require("mason-registry")`: `has_package(name)`, `get_package(name)`,
  `refresh(cb)`, `Package:is_installed()`, `Package:install(opts, cb)` with
  `cb(success, err)`.
- conform resolves formatters via `vim.fn.exepath(command)`
  (`conform.nvim/lua/conform/runner.lua:24`) → also `$PATH`.

## The mechanism

- Flip `mason.nvim` to `PATH = "append"`. Mason's bin dir goes to the **end** of
  `$PATH`, so Nix-shell tools (front) win when present and Mason is a pure
  fallback. This one setting fixes precedence for **both** LSP and formatters.
- Turn **off** `mason-lspconfig.automatic_enable` and drop `ensure_installed`.

### What replaces `ensure_installed`?

`ensure_installed` did two jobs at once — **install** the package *and*
(implicitly, via `automatic_enable`) **enable** the server. We split those:

| Old job | New mechanism |
|---|---|
| *Enable the server* | An **explicit server list** in `lua/core/lsp-registry.lua`, enabled via native `vim.lsp.enable()`, **FileType-gated** (a server is only touched when a buffer of its filetype opens — "if and only if functionality is requested"). |
| *Install the package* | **On-demand only.** `lua/core/mason-fallback.lua` installs a package **exclusively** when the requested binary is missing from `$PATH` at the moment its filetype is opened. Nothing is pre-installed. |

So `ensure_installed` isn't replaced by another "install everything" list — the
install step becomes lazy and conditional, and enablement becomes an explicit,
readable list you own. The FileType gate re-checks `executable()` at open time,
which is also what makes it robust to direnv loading `$PATH` slightly after
startup.

### Worked examples (3 languages from the current config)

**Go — `gopls` (open `main.go`):**
- Inside a Nix `go` devshell → `executable("gopls") == 1` (Nix store) →
  `vim.lsp.enable("gopls")`; the Nix gopls attaches.
- Outside, but Mason already has it → `executable("gopls") == 1` via Mason's
  appended bin → enable; Mason's gopls attaches (fallback already in place).
- Outside, not installed anywhere → `executable("gopls") == 0` → notify
  "installing gopls via Mason" → `Package:install` → on success enable → attach.

**Nix — `nil_ls` (open `flake.nix`):** illustrates that server name, binary
name, and Mason package name all differ. Server `nil_ls`, binary `nil`, Mason
package `nil`.
- Nix shell providing `nil` → `executable("nil") == 1` → enable; shell `nil`.
- Not present → mapping resolves `nil_ls` → package `nil` → install → enable.

**Rust — `rust_analyzer` (open `main.rs`):** now uniform, no special-casing.
- rustup/Nix shell providing `rust-analyzer` → `executable("rust-analyzer") == 1`
  → enable; shell binary runs.
- Not present → Mason installs `rust-analyzer` → enable. (Previously this was
  warn-only via `project_servers`; now it behaves like every other server.)

## Files to change

### 1. `lua/plugins/lsp/mason.lua` — Mason as fallback, no auto-enable

Replace contents:

```lua
return {
  {
    "mason-org/mason-lspconfig.nvim",
    -- We enable servers explicitly (native-first). Mason only installs on
    -- demand when a requested tool is missing from $PATH.
    opts = { automatic_enable = false },
    dependencies = {
      -- PATH="append": Nix-shell tooling wins; Mason bin dir is the fallback.
      { "mason-org/mason.nvim", opts = { PATH = "append" } },
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp", -- loaded before setup() so capabilities resolve
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts) -- honours automatic_enable = false
      require("core.lsp-registry").setup()    -- the ONE place servers are wired up
    end,
  },
}
```

Drops `ensure_installed`. This is also the **single invocation point** —
`lsp-registry.setup()` is called here and nowhere else; the server list itself
*lives* in the registry (§3).

### 2. `lua/core/mason-fallback.lua` — NEW: shared on-demand installer

A single low-level primitive reused by both the LSP registry and conform, so the
"install a Mason package on demand" logic lives in one place.

```lua
-- M.install(pkg_name, on_ready)
--   Ensures a Mason package is installed, then calls on_ready() (scheduled).
--   No-op with a warning if the package name is unknown to Mason.
local M = {}
function M.install(pkg_name, on_ready)
  local reg = require("mason-registry")
  reg.refresh(function()
    if not reg.has_package(pkg_name) then
      vim.notify(("Mason: no package '%s'"):format(pkg_name), vim.log.levels.WARN)
      return
    end
    local pkg = reg.get_package(pkg_name)
    if pkg:is_installed() then vim.schedule(on_ready); return end
    vim.notify(("Mason: installing '%s'…"):format(pkg_name), vim.log.levels.INFO)
    pkg:install({}, function(success)
      vim.schedule(function()
        if success then
          vim.notify(("Mason: '%s' installed"):format(pkg_name), vim.log.levels.INFO)
          on_ready()
        else
          vim.notify(("Mason: '%s' install failed"):format(pkg_name), vim.log.levels.ERROR)
        end
      end)
    end)
  end)
end
return M
```

### 3. `lua/core/lsp-registry.lua` — NEW: native-first enable + on-demand fallback

**The single source of truth for LSP servers.** Owns the server list, the
capabilities, the FileType-gated enable, and the uniform Mason fallback. Nothing
outside this file defines which servers exist. Key pieces:

- `servers` → a local list of `"name"` strings; **the** definition of which
  servers this config manages (no per-server flags — uniform treatment).
- `capabilities()` → native defaults merged with `cmp_nvim_lsp`'s caps via
  `pcall`, so the registry doesn't hard-depend on the completion plugin.
- `server_bin(server)` → reads `vim.lsp.config[server]`, returns `cmd[1]` +
  `filetypes`.
- `enable(server)` → `pcall(vim.lsp.enable, server)`.
- `ensure(server)` (runs once per server):
  - no bare bin (function `cmd`) → `enable` (assume present),
  - `executable(bin) == 1` → `enable` (Nix or already-Mason-installed),
  - else → look up package via `get_mason_map().lspconfig_to_package[server]`
    and call `require("core.mason-fallback").install(pkg, function() enable(server) end)`.
- `M.setup()` (no args — reads the internal `servers`):
  - set `vim.lsp.config("*", { capabilities = capabilities() })`,
  - build `filetype -> {servers}` from each server's resolved `filetypes`,
  - register one `FileType` autocmd (augroup `UserLspEnsure`) → `ensure`,
  - sweep already-loaded buffers (handles `nvim main.go`) → `ensure` per ft.

```lua
-- the one list; everything else derives from it
local servers = {
  "lua_ls", "pyright", "clangd", "cmake", "dockerls",
  "docker_compose_language_service", "bashls", "terraformls",
  "yamlls", "jsonls", "nil_ls", "ts_ls", "html", "cssls",
  "tailwindcss", "zls", "cue", "gopls", "rust_analyzer",
}
```

### 4. `lua/plugins/lsp/lsp.lua` — trimmed to just lazydev

**Answering the "defined in more than one place" concern:** there was no good
justification for the server list living inside the `cmp-nvim-lsp` *completion*
plugin — it ended up there only because that block also set `capabilities`. Both
concerns now move out: the list becomes the registry's `servers` (§3, the single
source of truth) and `capabilities` are resolved inside the registry. So the
`cmp-nvim-lsp` block here is deleted; `cmp-nvim-lsp` becomes a dependency of the
mason-lspconfig spec (§1) so it loads before `setup()`. It is still what
nvim-cmp uses for its `nvim_lsp` source — the `nvim-cmp.lua` spec is unaffected.
The old `project_servers` loop is deleted.

What remains in this file:

```lua
return {
  { "folke/lazydev.nvim", opts = {} },
}
```

**Single-source-of-truth check:** servers are now *defined* in exactly one place
(`lsp-registry.lua`'s `servers`) and *wired up* from exactly one place (the
`config` in §1). `mason.lua` holds infra + the one setup call; `lsp.lua` holds no
server list at all.

### 5. `lua/plugins/conform.lua` — formatters: native-first + on-demand install

- **PATH fix:** delete the hardcoded
  `rustfmt = { command = "/Users/dev/.cargo/bin/rustfmt" }` override (lines
  23-27). With `PATH="append"`, bare `rustfmt` resolves Nix-shell-first and falls
  back to the cargo/Mason copy — matching the native-first goal.
- **On-demand formatter install (in scope):** wrap the `<leader>f` handler so it
  first inspects `conform.list_formatters_to_run(bufnr)`; for any formatter whose
  binary is missing (`vim.fn.executable(name) == 0`), call
  `require("core.mason-fallback").install(name, run_format)` — reusing the same
  helper from §2. The formatter name is used as the Mason package name
  (`stylua`, `black`, `isort`, `prettier`, `golines`, `nixfmt`, `clang-format`
  all match 1:1). Toolchain-only formatters with no Mason package (`gofmt`,
  `rustfmt`) are simply skipped with the helper's "no package" warning and left
  to `$PATH` — which is correct, since they ship with their toolchains/Nix shell.

## Why this satisfies the goal

| Situation | Behavior |
|---|---|
| Tool in Nix shell | `executable()==1` → `vim.lsp.enable`, Nix binary runs (front of PATH) |
| Not in shell, already Mason-installed | `executable()==1` (Mason bin appended) → enable, Mason copy runs |
| Not in shell, not installed, file opened | auto Mason install + notify → enable |
| Filetype never opened | nothing installed (on-demand only) |
| Formatter missing on `<leader>f` | install matching Mason package (if any) → format |

## Verification

1. `nvim --headless "+checkhealth mason" +q` — confirm `PATH: append`.
2. **Native path:** in a Nix shell providing `gopls`, `nvim main.go` →
   `:checkhealth vim.lsp` (or `:LspInfo`) shows gopls attached;
   `:lua print(vim.lsp.get_clients({name="gopls"})[1].config.cmd[1])` then
   `:lua print(vim.fn.exepath("gopls"))` — confirm it points into the Nix store,
   not `~/.local/share/nvim/mason`.
3. **On-demand fallback:** pick a server not in the shell and not yet installed
   (e.g. `zls`), confirm `:lua print(vim.fn.executable("zls"))` prints `0`, open
   its filetype → expect the "installing … via Mason" notification, then the
   server attaches.
4. **Uniform rust:** outside any Rust shell with `rust-analyzer` absent from
   `$PATH`, open a `.rs` file → expect Mason to install `rust-analyzer` (no
   special warn-only behavior), then attach.
5. **On-demand only:** start nvim, open nothing relevant, `:Mason` → confirm no
   unrequested servers were installed.
6. **Formatters:** `stylua` still formats lua via `<leader>f` (resolving
   shell/Mason binary through PATH); with a missing-but-Mason-available formatter
   (e.g. `black` absent), `<leader>f` in a `.py` triggers the install then
   formats. `:messages` clean throughout.

## Status

Decisions settled: auto-install uses a non-blocking `vim.notify` (never a y/n
confirm). Scope is limited to LSP enablement/precedence and conform formatters;
the completion engine is left untouched. Ready to implement.
