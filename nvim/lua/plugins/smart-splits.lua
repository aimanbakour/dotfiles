return {
  "mrjones2014/smart-splits.nvim",
  version = ">=1.0.0",
  config = function()
    require("smart-splits").setup({
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "NvimTree" },
      default_amount = 3,
      at_edge = "wrap",
    })

    -- Recommended keymaps
    -- Resizing splits (leader + wr + direction)
    vim.keymap.set("n", "<leader>wrh", require("smart-splits").resize_left, { desc = "Resize split left" })
    vim.keymap.set("n", "<leader>wrj", require("smart-splits").resize_down, { desc = "Resize split down" })
    vim.keymap.set("n", "<leader>wrk", require("smart-splits").resize_up, { desc = "Resize split up" })
    vim.keymap.set("n", "<leader>wrl", require("smart-splits").resize_right, { desc = "Resize split right" })

    -- Moving between splits
    vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left, { desc = "Move to left split" })
    vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down, { desc = "Move to split below" })
    vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up, { desc = "Move to split above" })
    vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right, { desc = "Move to right split" })

    -- Swapping buffers between windows
    vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left, { desc = "Swap buffer left" })
    vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down, { desc = "Swap buffer down" })
    vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up, { desc = "Swap buffer up" })
    vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right, { desc = "Swap buffer right" })
  end,
}