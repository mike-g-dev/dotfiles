local status, comment = pcall(require, 'Comment')
if not status then
  print('Comment not installed!')
  return
end

comment.setup()
