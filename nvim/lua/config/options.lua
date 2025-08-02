-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable lua language server to prevent warning
vim.g.lazyvim_lua_ls = false

-- Show only diagnostic signs, not inline text (better for ADHD/focus)
vim.diagnostic.config({
  virtual_text = false,  -- Disable inline diagnostic text
  signs = true,         -- Show signs in gutter
  underline = true,     -- Keep underlines
})
