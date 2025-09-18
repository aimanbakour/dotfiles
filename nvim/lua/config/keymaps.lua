-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save file shortcuts
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })

-- Make file executable
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set(
	"v",
	"J",
	":m '>+1<CR>gv=gv",
	{ desc = "Move selected lines down" }
)
vim.keymap.set(
	"v",
	"K",
	":m '<-2<CR>gv=gv",
	{ desc = "Move selected lines up" }
)

vim.keymap.set(
	"n",
	"J",
	"mzJ`z",
	{ desc = "Join lines but keep cursor position" }
)
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search prev and center" })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d]])

-- vim.keymap.set(
--   "n",
--   "<leader>r",
--   [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
--   { desc = "Search and replace word under cursor" }
-- )

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Disable accidental marks
vim.keymap.set("n", "m", "<Nop>")
vim.keymap.set("n", "M", "m")

-- Diagnostic toggle
vim.keymap.set(
	"n",
	"<leader>td",
	"<cmd>DiagnosticsToggle<cr>",
	{ desc = "Toggle diagnostics" }
)

-- FzfLua
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", {
	desc = "Find document symbols",
})
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", {
	desc = "Find diagnostics locations",
})
vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua<cr>", {})
-- Deleting existing ones from LazyVim
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

-- Solve symbol layer bleeding
vim.cmd("cnoreabbrev { w")

-- :w layer bleeding problem
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { noremap = true, silent = true })
