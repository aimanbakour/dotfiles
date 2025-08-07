-- UI customizations
return {
  -- Disable bufferline (tabs at top)
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  -- Disable noice.nvim to get classic command line
  {
    "folke/noice.nvim",
    enabled = false,
  },
  -- Disable lualine to use built-in statusline (Prime style)
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
}
