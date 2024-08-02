return {
  "mfussenegger/nvim-dap-python",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    -- TODO: this is still not good...
    local python = vim.fn.getcwd() .. "/venv/bin/python"
    require("dap-python").setup(python)
  end,
}
