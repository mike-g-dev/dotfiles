return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local colorscheme = vim.g.colors_name
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = colorscheme,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          "buffers",
        },
      },
    })
  end,
}
