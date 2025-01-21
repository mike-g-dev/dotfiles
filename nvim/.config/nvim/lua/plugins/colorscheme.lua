return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("tokyonight").setup({
  --       style = "moon",
  --       transparent = true,
  --     })
  --     vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { bold = true },
        statementStyle = { bold = true },
        typeStyle = { bold = true },
        transparent = true, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = { wave = { }, lotus = {}, dragon = {}, all = { ui = { bg_gutter = "none" } } },
        },
        overrides = function(colors) -- add/modify highlights
          local theme = colors.theme
          return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          }
        end,
        theme = "wave",
      })

      vim.cmd([[colorscheme kanagawa]])
    end,
  },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("rose-pine").setup({
  --       variant = "auto",
  --       styles = {
  --         transparency = true,
  --       },
  --     })
  --     vim.cmd([[colorscheme rose-pine]])
  --   end,
  -- },
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
  --   "vague2k/vague.nvim",
  --   config = function()
  --     require("vague").setup({
  --       transparent = true,
  --     })
  --     vim.cmd([[colorscheme vague]])
  --   end,
  -- },
  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("onedark").setup({
  --       style = "warm",
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
  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd([[colorscheme solarized-osaka]])
  --   end,
  -- },
}
