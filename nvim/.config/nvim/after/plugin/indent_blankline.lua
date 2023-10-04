-- See `:help indent_blankline.txt`
local status, indent_blankline = pcall(require, 'ibl')
if not status then
  print('indent_blankline not installed')
  return
end

indent_blankline.setup {
  indent = { char = '┊' },
}
