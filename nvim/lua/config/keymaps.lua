-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Save file shortcuts
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })

-- Global file search (system-wide)
vim.keymap.set("n", "<leader>fG", function()
  require("fzf-lua").files({ cwd = "~" })
end, { desc = "Find files globally (home directory)" })

-- Code projects search
vim.keymap.set("n", "<leader>fC", function()
  require("fzf-lua").files({ cwd = "~/Developer" })
end, { desc = "Find files in code projects" })
