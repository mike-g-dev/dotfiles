return {
  {
    "hrsh7th/cmp-nvim-lsp",
    config = function ()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Servers provided by the active project's toolchain (resolved from
      -- $PATH, e.g. a Nix dev shell via direnv) rather than Mason.
      -- server name -> expected executable on $PATH.
      local project_servers = { rust_analyzer = "rust-analyzer" }
      for server, bin in pairs(project_servers) do
        local ok, err = pcall(vim.lsp.enable, server)
        if not ok then
          vim.notify(
            ("LSP: failed to enable '%s': %s"):format(server, err),
            vim.log.levels.ERROR
          )
        elseif vim.fn.executable(bin) == 0 then
          vim.notify(
            ("LSP: '%s' enabled but '%s' not found on $PATH — "
              .. "launch nvim inside the project's dev shell (direnv)."):format(server, bin),
            vim.log.levels.WARN
          )
        end
      end
    end,
  },
  {
    "folke/lazydev.nvim",
    opts = {}
  }
}
