vim.keymap.set('n', '<leader>a', function()
  vim.cmd '$argadd %'
  vim.cmd 'argdedup'
end)
vim.keymap.set('n', '<C-1>', function()
  vim.cmd 'silent! 1argument'
end)
vim.keymap.set('n', '<C-2>', function()
  vim.cmd 'silent! 2argument'
end)
vim.keymap.set('n', '<C-3>', function()
  vim.cmd 'silent! 3argument'
end)
vim.keymap.set('n', '<C-4>', function()
  vim.cmd 'silent! 4argument'
end)
vim.keymap.set('n', '<C-5>', function()
  vim.cmd 'silent! 5argument'
end)
