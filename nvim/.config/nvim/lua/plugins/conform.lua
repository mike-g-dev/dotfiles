return {
  "stevearc/conform.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang-format" },
        rust = { "rustfmt" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        go = { "gofmt", "golines" },
        nix = { "nixfmt" },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      local bufnr = vim.api.nvim_get_current_buf()

      local function run_format()
        conform.format({
          bufnr = bufnr,
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end

      -- Native-first: format straight away if every formatter resolves on
      -- $PATH. For any that is missing, fall back to a best-effort Mason install
      -- (formatter name == Mason package name) and format once it lands.
      -- Toolchain-only formatters with no Mason package (gofmt, rustfmt) are
      -- skipped by the helper's "no package" warning and left to $PATH.
      local missing = {}
      for _, fmt in ipairs(conform.list_formatters_to_run(bufnr)) do
        if fmt.command and vim.fn.executable(fmt.command) == 0 then
          table.insert(missing, fmt.name)
        end
      end

      if #missing == 0 then
        run_format()
        return
      end

      local mason_fallback = require("core.mason-fallback")
      for _, name in ipairs(missing) do
        mason_fallback.install(name, run_format)
      end
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
