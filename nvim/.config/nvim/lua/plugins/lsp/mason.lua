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
      require("core.lsp-registry").setup() -- the ONE place servers are wired up
    end,
  },
}
