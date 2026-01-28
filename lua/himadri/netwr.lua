-- ~/.config/nvim/lua/popup_explorer/init.lua

vim.g.netrw_banner = 0 -- Hide banner
vim.g.netrw_liststyle = 1 -- Tree view
vim.g.netrw_browse_split = 0 -- Open in current window
vim.g.netrw_altv = 1 -- Split to the right
vim.g.netrw_winsize = 20
vim.g.netrw_keepdir = 0
vim.g.netrw_localcopydircmd = 'cp -r'

-- Toggle netrw using :Lexplore
local function toggle_netrw()
  local netrw_open = false

  -- Check if any window is a Netrw buffer
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == 'netrw' then
      netrw_open = true

      -- Close netrw window
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- Open netrw sidebar (uses last width defined by netrw_winsize)
  vim.cmd 'Lexplore'
end

--vim.keymap.set('n', '<leader>e', toggle_netrw, {
--desc = 'Toggle Netrw file explorer',
--})
