-- See `:help indent_blankline.txt`
local status, indent_blankline = pcall(require, 'indent_blankline')
if not status then
  print('indent_blankline not installed')
  return
end

indent_blankline.setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}
