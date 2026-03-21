local keymap = vim.keymap
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = "[R]e[n]ame"
    keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

    opts.desc = "[C]ode [A]ction"
    keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "[G]oto [D]efinition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "[G]oto [R]eferences"
    keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)

    opts.desc = "[G]oto [I]mplementation"
    keymap.set("n", "gI", vim.lsp.buf.implementation, opts)

    opts.desc = "Hover Documentation"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Toggle diagnostic virtual_lines"
    keymap.set("n", "gK", function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, opts)

    opts.desc = "Signature Documentation"
    keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help, opts)
  end,
})
