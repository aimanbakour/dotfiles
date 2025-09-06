return {
  "m00qek/baleia.nvim",
  version = "*",
  config = function()
    vim.g.baleia = require("baleia").setup({})

    -- Create commands to colorize buffer and show logs
    vim.api.nvim_create_user_command("BaleiaColorize", function()
      vim.g.baleia.once(vim.api.nvim_get_current_buf())
    end, { bang = true })

    vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
  end,
}