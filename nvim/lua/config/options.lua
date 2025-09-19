-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Line wrapping and display options
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Break at word boundaries
vim.opt.showbreak = "  ⤷ "
vim.opt.textwidth = 80 -- Highlight long lines
vim.opt.colorcolumn = "80" -- Show 80-char guide line

-- Disable lua language server to prevent warning
vim.g.lazyvim_lua_ls = false

-- Show only diagnostic signs, not inline text (better for ADHD/focus)
vim.diagnostic.config({
	virtual_text = false, -- Disable inline diagnostic text
	signs = true, -- Show signs in gutter
	underline = true, -- Keep underlines
})

-- Settings from Prime
vim.opt.guicursor = "" -- Disable cursor shape changes

vim.opt.nu = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

vim.opt.tabstop = 4 -- Tab displays as 4 spaces
vim.opt.softtabstop = 4 -- Tab key inserts 4 spaces
vim.opt.shiftwidth = 4 -- Indentation uses 4 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Auto-indent new lines intelligently

vim.opt.swapfile = false -- No .swp files
vim.opt.backup = false -- No backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Persistent undo location
vim.opt.undofile = true -- Save undo history to file

vim.opt.hlsearch = false -- Don't highlight search results
vim.opt.incsearch = true -- Show search matches as you type

vim.opt.termguicolors = true -- Enable true colors

vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.isfname:append("@-@") -- Allow @ and - in filenames for gf command

vim.opt.updatetime = 50 -- Faster updates (default 4000ms)

-- Show mode in command line (like Prime)
vim.opt.showmode = true -- Show INSERT, VISUAL, etc. in command line

-- Custom statusline (Prime style)
vim.opt.statusline = "%F %h%w%m%r %=                    %(%l,%c%V         %P%)"

-- Fix bash script detection for shebang
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*",
	callback = function()
		local first_line = vim.fn.getline(1)
		if first_line:match("^#!/usr/bin/env bash") then
			vim.bo.filetype = "bash"
		end
	end,
})

-- Toggle diagnostics command
vim.api.nvim_create_user_command("DiagnosticsToggle", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, {})

-- For Molten venv
vim.g.python3_host_prog =
	vim.fn.expand("~/.local/virtualenvs/neovim/bin/python")
