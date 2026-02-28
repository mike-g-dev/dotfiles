return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    tag = "v0.10.0",
    lazy = false,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
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
          "lua",
          "make",
          "proto",
          "toml",
          "sql",
          "cue",
        },
        highlight = {
          enable = true, -- Enable syntax highlighting
        },
      })
    end,
  },
}
