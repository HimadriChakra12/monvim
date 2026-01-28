-- Dynamic Variables According to user Preference
local Dashboard_file_counter_number = 5
------------------------------------------------------------
-- Startup autocmd (numbers + intro handling)
------------------------------------------------------------
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "" then
			vim.opt.shortmess:append("I")
		else
			vim.opt.number = false
			vim.opt.relativenumber = true
		end
	end,
})

------------------------------------------------------------
-- Git status helper
------------------------------------------------------------
local function get_git_status()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
	if not git_root or git_root == "" then
		return nil
	end

	local branch = vim.fn.systemlist("git branch --show-current")[1] or "detached"
	local status = vim.fn.systemlist("git status --porcelain")

	local staged, modified, untracked = 0, 0, 0

	for _, line in ipairs(status) do
		if line:sub(1, 2) == "??" then
			untracked = untracked + 1
		else
			if line:sub(1, 1) ~= " " then
				staged = staged + 1
			end
			if line:sub(2, 2) ~= " " then
				modified = modified + 1
			end
		end
	end

	return {
		branch = branch,
		staged = staged,
		modified = modified,
		untracked = untracked,
	}
end

------------------------------------------------------------
-- Dashboard
------------------------------------------------------------
local function show_dashboard()
	-- Only show when no file is provided
	if vim.fn.argc() ~= 0 or vim.fn.line2byte("$") ~= -1 then
		return
	end

	--------------------------------------------------------
	-- Highlights
	--------------------------------------------------------
	vim.cmd([[
        highlight! DashboardHeader     guifg=#b8bb26
        highlight! DashboardGitHeader  guifg=#fabd2f
        highlight! DashboardGitClean   guifg=#b8bb26
        highlight! DashboardGitDirty   guifg=#fb4934
    ]])

	--------------------------------------------------------
	-- Header
	--------------------------------------------------------
	local header = {
		"",
		"",
		"                    _______       .__         ",
		"  _____     ____  \\      \\___  _|__| _____  ",
		" /     \\ /  _ \\ /   |   \\  \\/ /  |/     \\ ",
		"|  Y Y   (  <_> )     |    \\   /|  |  Y Y  \\",
		"|__|_|  /\\____/\\____|__  /\\_/ |__|__|_|  /",
		"      \\/               \\/              \\/ ",
		"",
		"                  Neovim " .. vim.version().major .. "." .. vim.version().minor,
		"",
		"",
		"",
	}

	--------------------------------------------------------
	-- Pins
	--------------------------------------------------------
	local pinner = require("himadri.pin")
	local pins = pinner.get_pins()

	local pin_lines = { "  Pinned" }
	if #pins == 0 then
		table.insert(pin_lines, "  No files pinned.")
	else
		for _, pin in ipairs(pins) do
			table.insert(pin_lines, string.format("  %s. [%s]", pin.key, vim.fn.fnamemodify(pin.path, ":~")))
		end
	end

	--------------------------------------------------------
	-- Recent files
	--------------------------------------------------------
	local recent_files = {}
	local counter = 1

	for _, file in ipairs(vim.v.oldfiles) do
		if counter > Dashboard_file_counter_number then
			break
		end
		if vim.fn.filereadable(file) == 1 then
			table.insert(recent_files, {
				text = string.format("  %d. [%s]", counter, file),
				path = file,
			})
			counter = counter + 1
		end
	end

	--------------------------------------------------------
	-- Git status
	--------------------------------------------------------
	local git = get_git_status()

	--------------------------------------------------------
	-- Footer
	--------------------------------------------------------
	--------------------------------------------------------
	-- Buffer setup
	--------------------------------------------------------
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(buf, "Welcome, Himadri")

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "Sayo"
	vim.wo.number = false
	vim.wo.relativenumber = false

	--------------------------------------------------------
	-- Build content
	--------------------------------------------------------
	local content = vim.list_extend({}, header)
	vim.list_extend(content, pin_lines)

	table.insert(content, "")
	table.insert(content, "  Recent:")
	for _, item in ipairs(recent_files) do
		table.insert(content, item.text)
	end

	table.insert(content, "")
	table.insert(content, "  Git:")
	if not git then
		table.insert(content, "  Not a git repository")
	else
		table.insert(
			content,
			string.format("   %s  +%d  ~%d  ?%d", git.branch, git.staged, git.modified, git.untracked)
		)
	end

	--------------------------------------------------------
	-- Write buffer
	--------------------------------------------------------
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	-- Header highlights
	for i = 3, 8 do
		vim.api.nvim_buf_add_highlight(buf, -1, "DashboardHeader", i - 1, 0, -1)
	end

	-- Git highlights
	if git then
		local git_header_line = #header + #pin_lines + #recent_files + 4
		local git_line = git_header_line + 1

		vim.api.nvim_buf_add_highlight(buf, -1, "DashboardGitHeader", git_header_line, 0, -1)

		local clean = (git.staged + git.modified + git.untracked) == 0

		vim.api.nvim_buf_add_highlight(buf, -1, clean and "DashboardGitClean" or "DashboardGitDirty", git_line, 0, -1)
	end

	vim.bo[buf].modifiable = false
	vim.api.nvim_set_current_buf(buf)
	vim.api.nvim_win_set_cursor(0, { 21, 6 })

	--------------------------------------------------------
	-- Keymaps
	--------------------------------------------------------
	local opts = { buffer = buf, silent = true, nowait = true }

	-- Keybinds for recent files (1-5)
	for i, item in ipairs(recent_files) do
		vim.keymap.set("n", tostring(i), function()
			vim.cmd("edit " .. vim.fn.fnameescape(item.path))
		end, opts)
	end

	-- Keybinds for pinned files (p1, p2, p3, ...)
	for i, pin in ipairs(pins) do
		vim.keymap.set("n", "p" .. tostring(i), function()
			vim.cmd("edit " .. vim.fn.fnameescape(pin.path))
		end, opts)
	end

	local function open_selected()
		local line = vim.api.nvim_get_current_line()

		-- Pins
		local pin_key = line:match("^%s*([%a])%. ")
		if pin_key then
			for _, pin in ipairs(pins) do
				if pin.key == pin_key then
					vim.cmd("edit " .. vim.fn.fnameescape(pin.path))
					return
				end
			end
		end

		-- Recent files
		local path = line:match("%[(.*)%]")
		if path and vim.fn.filereadable(path) == 1 then
			vim.cmd("edit " .. vim.fn.fnameescape(path))
		end
	end

	vim.keymap.set("n", "<CR>", open_selected, opts)
	vim.keymap.set("n", "o", open_selected, opts)

	vim.keymap.set("n", "e", ":edit $MYVIMRC<CR>", opts)
	vim.keymap.set("n", "n", ":enew<CR>", opts)
	vim.keymap.set("n", "h", ":help<CR>", opts)
	vim.keymap.set("n", "q", ":q<CR>", opts)
end

------------------------------------------------------------
-- Autocmd + command
------------------------------------------------------------
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(show_dashboard)
	end,
	nested = true,
	desc = "Show custom dashboard",
})

vim.api.nvim_create_user_command("Dashboard", show_dashboard, {})
