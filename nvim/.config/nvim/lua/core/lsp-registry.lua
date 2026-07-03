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

-- Resolve the merged config for a server (incl. cmd/filetypes from
-- nvim-lspconfig's bundled lsp/<name>.lua). Returns the bare binary name
-- (cmd[1]) and the filetypes list. bin is nil when cmd is a function.
local function server_bin(server)
  local cfg = vim.lsp.config[server]
  if not cfg then
    return nil, nil
  end
  local bin
  if type(cfg.cmd) == "table" then
    bin = cfg.cmd[1]
  end
  return bin, cfg.filetypes
end

local function enable(server)
  local ok, err = pcall(vim.lsp.enable, server)
  if not ok then
    vim.notify(("LSP: failed to enable '%s': %s"):format(server, err), vim.log.levels.ERROR)
  end
end

-- Runs once per server.
local ensured = {}
local function ensure(server)
  if ensured[server] then
    return
  end
  ensured[server] = true

  local bin = server_bin(server)

  -- No bare binary (function cmd) → assume present, enable.
  if not bin then
    enable(server)
    return
  end

  -- On $PATH (Nix shell or already-Mason-installed) → enable.
  if vim.fn.executable(bin) == 1 then
    enable(server)
    return
  end

  -- Missing → on-demand Mason fallback, then enable.
  local pkg = require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package[server]
  if not pkg then
    vim.notify(("LSP: '%s' not on $PATH and has no Mason package mapping"):format(server), vim.log.levels.WARN)
    return
  end
  require("core.mason-fallback").install(pkg, function()
    enable(server)
  end)
end

function M.setup()
  vim.lsp.config("*", { capabilities = capabilities() })

  -- Build filetype -> { servers } from each server's resolved filetypes.
  local ft_map = {}
  for _, server in ipairs(servers) do
    local _, filetypes = server_bin(server)
    for _, ft in ipairs(filetypes or {}) do
      ft_map[ft] = ft_map[ft] or {}
      table.insert(ft_map[ft], server)
    end
  end

  local function ensure_ft(ft)
    for _, server in ipairs(ft_map[ft] or {}) do
      ensure(server)
    end
  end

  -- FileType-gated: a server is only touched when a buffer of its filetype
  -- opens ("if and only if functionality is requested"). Re-checking
  -- executable() at open time is what makes this robust to direnv loading
  -- $PATH slightly after startup.
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserLspEnsure", { clear = true }),
    callback = function(ev)
      ensure_ft(ev.match)
    end,
  })

  -- Sweep already-loaded buffers (handles `nvim main.go`, where FileType has
  -- already fired before this autocmd was registered).
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      ensure_ft(vim.bo[buf].filetype)
    end
  end
end

return M
