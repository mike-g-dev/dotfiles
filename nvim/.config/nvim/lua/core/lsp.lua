--#region
--     local on_attach = function(_, bufnr)
--       local nmap = function(keys, func, desc)
--         if desc then
--           desc = "LSP: " .. desc
--         end
--
--         vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
--       end
--
--       nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
--       nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
--
--       nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
--       nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
--       nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
--       nmap("<leade>D", vim.lsp.buf.type_definition, "Type [D]efinition")
--       nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
--       nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
--       vim.keymap.set("n", "gK", function()
--         local new_config = not vim.diagnostic.config().virtual_lines
--         vim.diagnostic.config({ virtual_lines = new_config })
--       end, { desc = "Toggle diagnostic virtual_lines" })
--
--       -- See `:help K` for why this keymap
--       nmap("K", vim.lsp.buf.hover, "Hover Documentation")
--       nmap("<leader>sh", vim.lsp.buf.signature_help, "Signature Documentation")
--
--       -- Lesser used LSP functionality
--       nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
--       nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
--       nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
--       nmap("<leader>wl", function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--       end, "[W]orkspace [L]ist Folders")
--     end
-- --#endregion
--
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
