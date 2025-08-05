return {
  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      ensure_installed = {
        "typescript",
        "javascript",
        -- "python",
        -- "swift",
        "go",
      },
      -- Map filetypes to documentation
      filetypes = {
        typescript = "typescript",
        javascript = "javascript",
        -- python = "python",
        -- swift = "swift",
        go = "go",
      },
    },
  },
}

