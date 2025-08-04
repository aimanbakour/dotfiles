-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save file shortcuts
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })

-- Centered scrolling (Primeagen style)
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })

-- Custom fzf-lua keymaps are now in lua/plugins/fzf-lua.lua
