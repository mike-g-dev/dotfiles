local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

treesitter.setup({
  highlight = {
    enable = true
  },
  indent = { enable = true },
  ensure_installed = {
    "python",
    "bash",
    "rust",
    "lua",
    "cpp",
    "dockerfile",
    "gitignore",
    "json",
    "proto",
    "sql",
    "toml",
    "yaml",
  },
  auto_install = true,
})
