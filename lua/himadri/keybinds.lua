local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap('n', 'cd', ':Zcd ', { noremap = true })
keymap('n', '<leader>.', ':Zt<CR>', opts)
keymap('n', '<leader>e', ':Oil<CR>', opts)
keymap('v', '<leader>Y', '"+y', { silent = true, desc = 'Yamk' })

keymap('n', '<leader>g', ':Git<CR>', opts)
keymap('n', '<leader>gp', ':!git push<CR>', opts)
keymap('n', '<leader>gP', ':!git pull<CR>', opts)

keymap('n', ';;', ':w<CR>', opts)
