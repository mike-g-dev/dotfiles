return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        transparent = true,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  -- {
  --   "mellow-theme/mellow.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- vim.g.mellow_bold_functions = true
  --     -- vim.g.mellow_bold_variables = true
  --     vim.g.mellow_bold_keywords = true
  --     vim.g.mellow_transparent = true
  --     vim.cmd([[colorscheme mellow]])
  --   end,
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup({
  --       style = "deep",
  --       transparent = true,
  --       code_style = {
  --         comments = "italic",
  --         keywords = "bold",
  --         functions = "bold",
  --       },
  --     })
  --     vim.cmd([[colorscheme onedark]])
  --   end,
  -- },
  "craftzdog/solarized-osaka.nvim",
}
