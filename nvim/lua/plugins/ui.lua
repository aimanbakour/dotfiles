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
  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
  },
}
