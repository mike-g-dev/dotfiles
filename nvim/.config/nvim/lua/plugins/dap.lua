return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-ui",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()

    -- TODO: realistically, I would like to configure LSP and DAP for each language I use in one place...
    local python = os.getenv("VIRTUAL_ENV") .. "/bin/python"
    require("dap-python").setup(python)

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<leader>db", dap.continue, {})
  end,
}
