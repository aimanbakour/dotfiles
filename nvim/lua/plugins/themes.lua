-- Transparent background function (from Prime)
function ColorMyPencils(color)
    color = color or "catppuccin-frappe" -- Keep your default
    vim.cmd.colorscheme(color)
    
    -- Make background transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

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
        disable_background = true, -- Enable transparency like Prime
        disable_float_background = true,
        styles = {
          italic = false, -- Disable italics like Prime
        },
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
    priority = 1001, -- Higher priority than other themes
    lazy = false, -- Load immediately
    config = function()
      require("catppuccin").setup({
        flavour = "frappe", -- latte, frappe, macchiato, mocha
      })
      ColorMyPencils() -- Apply catppuccin-frappe with transparent background
    end
  }
}