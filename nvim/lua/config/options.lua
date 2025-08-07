-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable lua language server to prevent warning
vim.g.lazyvim_lua_ls = false

-- Show only diagnostic signs, not inline text (better for ADHD/focus)
vim.diagnostic.config({
  virtual_text = false, -- Disable inline diagnostic text
  signs = true, -- Show signs in gutter
  underline = true, -- Keep underlines
})

-- Set column guide for better focus (ADHD-friendly)
vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80 -- Auto wrap at 80 characters

-- Settings from Prime
vim.opt.guicursor = "" -- Disable cursor shape changes

vim.opt.nu = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

vim.opt.tabstop = 4 -- Tab displays as 4 spaces
vim.opt.softtabstop = 4 -- Tab key inserts 4 spaces
vim.opt.shiftwidth = 4 -- Indentation uses 4 spaces
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Auto-indent new lines intelligently

vim.opt.wrap = false -- Disable line wrapping

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
