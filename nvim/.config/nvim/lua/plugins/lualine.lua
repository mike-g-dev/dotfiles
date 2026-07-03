return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local colorscheme = vim.g.colors_name

    local NIX_GLYPH = "󱄅"

    local function render_lsp_source()
      local ok, registry = pcall(require, "core.lsp-registry")
      if ok and registry.buffer_uses_nix(0) then
        return NIX_GLYPH
      end
      return ""
    end

    vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
      group = vim.api.nvim_create_augroup("UserLualineNixLsp", { clear = true }),
      callback = function()
        vim.cmd("redrawstatus")
      end,
    })

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = colorscheme,
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_q = { "mode" },
        lualine_b = {
          "buffers",
        },
        lualine_x = { render_lsp_source },
      },
    })
  end,
}
