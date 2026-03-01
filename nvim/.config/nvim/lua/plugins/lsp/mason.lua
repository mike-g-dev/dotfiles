return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "rust_analyzer",
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
        "gopls"
      },
    },
    dependencies = {
      {"mason-org/mason.nvim", opts = {}},
      "neovim/nvim-lspconfig",
    },
  },
}
