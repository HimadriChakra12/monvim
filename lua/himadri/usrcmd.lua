--vim.api.nvim_create_user_command("PacmanSync", function()
--require("pacman.ghost").setup()
--end, {})
--vim.api.nvim_create_user_command("PacmanDash", function()
--require("pacman.maze").open()
--end, {})
--vim.api.nvim_create_user_command("PacmanDashboard", function()
--require("pacman.maze").open()
--end, {})

vim.api.nvim_create_user_command('ReaderMode', function()
  ToggleReaderMode()
end, { desc = 'Toggle distraction-free reader mode' })

vim.cmd [[
  cabbrev W  w!
  cabbrev Q  q
  cabbrev Wq wq!
  cabbrev WQ wq!
  cabbrev wQ wq!
]]

vim.keymap.set('n', '<leader>t', "<cmd>lua require('himadri.todo').telescope_todo_popup()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>i3', ':!i3-msg restart<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gp', ':Git push<CR>', { noremap = true, silent = true })
