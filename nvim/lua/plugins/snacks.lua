return {
  "folke/snacks.nvim",
  opts = {
    dim = { enabled = false },
    notifier = {
      level = vim.log.levels.TRACE,
      filter = function(notif)
        -- Hide devdocs notifications
        if
          notif.msg
          and type(notif.msg) == "string"
          and notif.msg:match("nvim%-devdocs")
        then
          return false
        end
        return true
      end,
    },
    terminal = {
      win = {
        style = "terminal",
        border = "none",
        wo = {
          winbar = "",
          winhighlight = "",
        },
        bo = {
          filetype = "snacks_terminal",
        },
      },
    },
  },
}
