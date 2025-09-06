return {
  {
    "luckasRanarison/nvim-devdocs",
    lazy = true,
    silent = true,
    cmd = { "DevdocsOpen", "DevdocsOpenFloat", "DevdocsInstall" },
    keys = {
      { "<leader>dd", "<cmd>DevdocsOpen<cr>", desc = "Open DevDocs" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-devdocs").setup({
        ensure_installed = {
          "typescript",
          "javascript",
          "go",
        },
        filetypes = {
          typescript = "typescript",
          javascript = "javascript",
          go = "go",
        },
        after_open = function(bufnr)
          -- Suppress notifications after opening docs
          local original_notify = vim.notify
          vim.notify = function() end
          vim.defer_fn(function() 
            vim.notify = original_notify 
          end, 500)
        end,
      })
    end,
  },
}
