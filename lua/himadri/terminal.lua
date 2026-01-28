-- Simple terminal toggle (horizontal)
local term_win = nil
local term_buf = nil

vim.keymap.set('n', '<leader>h', function()
  -- If terminal already open → close it
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
    return
  end

  -- Create buffer if needed
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    term_buf = vim.api.nvim_create_buf(false, true) -- nofile, scratch
  end

  -- Open split + window
  vim.cmd '15split'
  term_win = vim.api.nvim_get_current_win()

  -- Open terminal in buffer
  vim.fn.termopen(vim.o.shell)

  -- Enter insert mode
  vim.cmd 'startinsert'
end, { desc = 'Toggle horizontal terminal' })
