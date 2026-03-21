return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local parsers = {
        "c",
        "cpp",
        "zig",
        "go",
        "lua",
        "python",
        "rust",
        "typescript",
        "javascript",
        "vim",
        "vimdoc",
        "nix",
        "ocaml",
        "bash",
        "swift",
        "terraform",
        "hcl",
        "yaml",
        "json",
        "dockerfile",
        "gitignore",
        "markdown",
        "html",
        "make",
        "proto",
        "toml",
        "sql",
        "cue",
      }

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
