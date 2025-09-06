return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    Snacks.toggle({
      name = "Completion",
      get = function()
        return vim.b.completion ~= false
      end,
      set = function(state)
        vim.b.completion = state
      end,
    }):map("<leader>tc")

    -- Disable auto popup; show only when triggered
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = { auto_show = false },
    })
    return opts
  end,
}
