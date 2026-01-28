local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'

if is_windows then
  -- Prefer pwsh, fallback to powershell
  if vim.fn.executable 'pwsh' == 1 then
    vim.opt.shell = 'pwsh'
  else
    vim.opt.shell = 'powershell'
  end

  -- Required for :! and other shell commands to work correctly
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'

  -- Proper quoting and redirection behavior
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
  vim.opt.shellredir = '2>&1 | Out-File -Encoding UTF8 %s'
  vim.opt.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s'
end
