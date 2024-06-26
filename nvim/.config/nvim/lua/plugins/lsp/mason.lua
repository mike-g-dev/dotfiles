return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup()

    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
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
        "tsserver",
        "ocamllsp",
        "html",
        "cssls",
        "tailwindcss",
        "zls",
      },
    })

    local mason_tool_installer = require("mason-tool-installer")

    mason_tool_installer.setup({
      ensure_installed = {
        "stylua",
        "isort",
        "black",
        "clang-format",
        "eslint_d",
        "prettier",
      },
    })
  end,
}
