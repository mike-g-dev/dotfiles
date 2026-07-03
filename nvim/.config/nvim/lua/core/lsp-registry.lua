-- The single source of truth for LSP servers.
--
-- Native-first: every server is enabled via native `vim.lsp.enable()` assuming
-- its binary is already on $PATH (e.g. a Nix dev shell via direnv). If and only
-- if the binary is missing when its filetype is opened do we fall back to
-- installing it via Mason, then enable it. Nothing outside this file defines
-- which servers this config manages.

local M = {}

local servers = {
  "lua_ls",
  "pyright",
  "clangd",
  "cmake",
  "dockerls",
  "docker_compose_language_service",
  "bashls",
  "terraformls",
  "yamlls",
  "jsonls",
  "nil_ls",
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "zls",
  "cue",
  "gopls",
  "rust_analyzer",
}

-- Native defaults merged with cmp_nvim_lsp's capabilities. pcall so the registry
-- does not hard-depend on the completion plugin.
local function capabilities()
  local caps = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    caps = vim.tbl_deep_extend("force", caps, cmp_nvim_lsp.default_capabilities())
  end
  return caps
end

-- The Mason package that provides a server's binary (nil if none / unmapped).
local function mason_pkg(server)
  return require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package[server]
end

function M.setup()
  vim.lsp.config("*", { capabilities = capabilities() })

  -- Native-first: `vim.lsp.enable` owns all the filetype handling for us — it
  -- registers a single FileType autocmd, gates each server on its own
  -- `filetypes`, re-checks `executable(cmd[1])` at open time (robust to direnv),
  -- and sweeps already-loaded buffers. A missing binary is simply skipped.
  vim.lsp.enable(servers)

  -- The one thing native does NOT do: install a genuinely-absent tool. When a
  -- server's filetype opens but its binary isn't on $PATH, install the Mason
  -- package on demand, then re-`enable` so native starts it. Runs once per
  -- server. Toolchain-only servers with no Mason package are left to $PATH.
  local pending = {}
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspMasonFallback", { clear = true }),
    callback = function(ev)
      for _, server in ipairs(servers) do
        local cfg = vim.lsp.config[server]
        local bin = cfg and type(cfg.cmd) == "table" and cfg.cmd[1] or nil
        local applies = cfg and type(cfg.filetypes) == "table"
          and vim.tbl_contains(cfg.filetypes, ev.match)
        if applies and bin and not pending[server] and vim.fn.executable(bin) == 0 then
          local pkg = mason_pkg(server)
          if pkg then
            pending[server] = true
            require("core.mason-fallback").install(pkg, function()
              vim.lsp.enable(server) -- re-trigger native start now the binary exists
            end)
          end
        end
      end
    end,
  })
end

function M.buffer_uses_nix(bufnr)
  bufnr = bufnr or 0
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    local cmd = client.config and client.config.cmd
    local bin = type(cmd) == "table" and cmd[1] or nil
    if bin then
      local path = vim.fn.exepath(bin)
      if path == "" then
        path = bin
      end
      if path:lower():find("/nix/", 1, true) then
        return true
      end
    end
  end
  return false
end

return M
