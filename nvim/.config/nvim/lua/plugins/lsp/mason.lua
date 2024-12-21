return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    require("mason").setup()

    require("mason-nvim-dap").setup({
      ensure_installed = { "debugpy", "codelldb" },
    })

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
        "ts_ls",
        "ocamllsp",
        "html",
        "cssls",
        "tailwindcss",
        "zls",
        "gopls",
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
        "delve",
        "golines",
      },
    })
  end,
}
