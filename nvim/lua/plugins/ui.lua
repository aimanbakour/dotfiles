-- UI customizations
return {
  -- Disable bufferline (tabs at top)
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  -- Configure noice.nvim to use normal cmdline instead of floating
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline", -- Use normal cmdline instead of cmdline_popup
      },
    },
  },
}