return {
  {
    "morhetz/gruvbox",
    priority = 1000,
    config = function()
      vim.g.gruvbox_contrast_dark = "hard"
    end
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
        disable_background = false,
        disable_float_background = false,
      })
    end
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} }
        },
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
    end
  },
  {
    "Shatur/neovim-ayu",
    priority = 1000,
    config = function()
      require("ayu").setup({
        mirage = false,
        terminal = true,
      })
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
      })
      vim.cmd.colorscheme "catppuccin-frappe"
    end
  }
}