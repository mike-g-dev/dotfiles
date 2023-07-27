local status, neodev = pcall(require, 'neodev')
if not status then
  print('neodev not installed!')
  return
end

neodev.setup()
