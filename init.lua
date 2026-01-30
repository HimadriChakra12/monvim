--OPTs

vim.o.path = "**"
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = false
vim.o.relativenumber = true
vim.o.mouse = ""
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = false
vim.o.scrolloff = 10
vim.o.confirm = true
vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.softtabstop = 4 -- Number of spaces inserted when pressing TAB
vim.opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.g.mkdp_preview_options = {
	katex = {},
}
vim.opt.wrap = true
vim.opt.linebreak = true
vim.o.conceallevel = 2

--CUSTOM
require("himadri.himadri")
require("theradlectures.terminalflaot")

--KEYMAPs
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	"NMAC427/guess-indent.nvim",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"lervag/vimtex",
		ft = { "tex", "markdown" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"nvim-tree/nvim-web-devicons",
		enabled = vim.g.have_nerd_font,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				winopts = {
					height = 0.95,
					width = 0.95,
					preview = {
						vertical = "down:45%",
						wrap = "nowrap",
					},
				},
				keymap = {
					builtin = {
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
					},
				},
			})

			-- Keymaps (Telescope → fzf-lua equivalents)
			vim.keymap.set("n", "<leader>o", fzf.files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>f", fzf.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
			vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>oo", fzf.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Search in buffer" })
			vim.keymap.set("n", "<leader>c", function()
				fzf.files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Neovim config files" })
		end,
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			-- Diagnostics (clean + readable)
			vim.diagnostic.config({
				severity_sort = true,
				underline = true,
				virtual_text = {
					spacing = 2,
					source = "if_many",
				},
				float = {
					border = "rounded",
					source = "if_many",
				},
			})

			-- LSP attach: keymaps + small extras
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, {
							buffer = event.buf,
							desc = "LSP: " .. desc,
						})
					end

					map("gd", vim.lsp.buf.definition, "Definition")
					map("gr", vim.lsp.buf.references, "References")
					map("gi", vim.lsp.buf.implementation, "Implementation")
					map("K", vim.lsp.buf.hover, "Hover")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					-- Inlay hints toggle (only if supported)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay Hints")
					end
				end,
			})

			-- Capabilities (completion)
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Servers (keep it tight)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
						},
					},
				},
				bashls = {
					filetypes = { "sh", "bash", "zsh" },
				},
			}

			-- Ensure tools
			require("mason-tool-installer").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- Setup servers
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci", "-bn", "-sr" },
				},
			},
		},
	},
	{ -- You can easily change to a different colorscheme.
		"ellisonleao/gruvbox.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("gruvbox").setup({
				styles = {
					comments = { italic = false }, -- Disable italics in comments
				},
			})
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
		end,
	},
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown", -- or 'event = "VeryLazy"'
		opts = {
			-- Disable all keymaps by setting mappings field to 'false'.
			-- Selectively disable keymaps by setting corresponding field to 'false'.
			mappings = {
				inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
				inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
				inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
				inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
				link_add = "gl", -- (string|boolean) add link
				link_follow = "gx", -- (string|boolean) follow link
				go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
				go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
				go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
				go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
			},
			inline_surround = {
				emphasis = {
					key = "i",
					txt = "*",
				},
				strong = {
					key = "b",
					txt = "**",
				},
				strikethrough = {
					key = "s",
					txt = "~~",
				},
				code = {
					key = "c",
					txt = "`",
				},
			},
			link = {
				paste = {
					enable = true, -- whether to convert URLs to links on paste
				},
			},
			toc = {
				-- Comment text to flag headings/sections for omission in table of contents.
				omit_heading = "toc omit heading",
				omit_section = "toc omit section",
				-- Cycling list markers to use in table of contents.
				-- Use '.' and ')' for ordered lists.
				markers = { "-" },
			},
			-- Hook functions allow for overriding or extending default behavior.
			-- Called with a table of options and a fallback function with default behavior.
			-- Signature: fun(opts: table, fallback: fun())
			hooks = {
				-- Called when following links. Provided the following options:
				-- * 'dest' (string): the link destination
				-- * 'use_default_app' (boolean|nil): whether to open the destination with default application
				--   (refer to documentation on <Plug> mappings for explanation of when this option is used)
				follow_link = nil,
			},
			on_attach = nil, -- (fun(bufnr: integer)) callback when plugin attaches to a buffer
		},
	},
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs", -- Sets main module to use for opts
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"latex",
			},
			auto_install = true,
			highlight = {
				enable = true,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
		{
			"ck-zhang/mistake.nvim",
			config = function()
				local plugin = require("mistake")
				vim.defer_fn(function()
					plugin.setup()
				end, 500)

				vim.keymap.set("n", "<leader>ma", plugin.add_entry, { desc = "[M]istake [A]dd entry" })
				vim.keymap.set("n", "<leader>me", plugin.edit_entries, { desc = "[M]istake [E]dit entries" })
				vim.keymap.set(
					"n",
					"<leader>mc",
					plugin.add_entry_under_cursor,
					{ desc = "[M]istake add [C]urrent word" }
				)
			end,
		},
		{
			"stevearc/oil.nvim",
			opts = {
				default_file_explorer = true,

				-- Minimal columns (icons optional)
				columns = {
					"icon",
					"permissions",
				},

				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},

				win_options = {
					wrap = false,
					signcolumn = "no",
					cursorcolumn = false,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 3,
				},

				-- Less friction
				delete_to_trash = false,
				skip_confirm_for_simple_edits = true,
				prompt_save_on_select_new_entry = false,
				cleanup_delay_ms = 1000,

				-- LSP integration off (less lag on mobile)
				lsp_file_methods = {
					enabled = false,
				},

				constrain_cursor = "editable",
				watch_for_changes = false,

				-- Minimal keymaps (thumb-friendly)
				keymaps = {
					["<CR>"] = "actions.select",
					["-"] = "actions.parent",
					["g."] = "actions.toggle_hidden",
					["<C-l>"] = "actions.refresh",
					["q"] = "actions.close",
				},

				use_default_keymaps = false,

				view_options = {
					show_hidden = false,
					natural_order = true,
					case_insensitive = true,
					sort = {
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},

				-- Disable all float/preview UI
				float = { enabled = false },
				preview_win = { disable_preview = true },
				confirmation = { enabled = false },
				progress = { enabled = false },

				-- Disable git helpers (less surprise edits)
				git = {
					add = function()
						return false
					end,
					mv = function()
						return false
					end,
					rm = function()
						return false
					end,
				},
			},

			dependencies = {
				{ "nvim-mini/mini.icons", opts = {} },
			},

			lazy = false,
		},
	},
	-- require 'kickstart.plugins.debug',
	require("kickstart.plugins.indent_line"),
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',
	require("kickstart.plugins.gitsigns"), -- adds gitsigns recommend keymaps
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
