return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      -- Take over directory buffers (vim . or :e src/)
      default_file_explorer = true,
      -- Columns to show
      columns = {
        "icon",
        "permissions",
        "size",
      },
      -- Send deleted files to trash (safer)
      delete_to_trash = true,
      -- Skip confirmation for simple operations
      skip_confirm_for_simple_edits = true,
      -- Show hidden files by default (toggle with g.)
      view_options = {
        show_hidden = false,
      },
    })
    
    -- Keymaps for opening oil
    vim.keymap.set("n", "<leader>o", function()
      require("oil").open(vim.fn.expand("%:p:h"))
    end, { desc = "Open current file's directory" })
    
    vim.keymap.set("n", "-", function()
      require("oil").open(vim.fn.expand("%:p:h"))
    end, { desc = "Open parent directory" })
  end,
}