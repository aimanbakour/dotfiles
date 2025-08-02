-- Undo tree visualization
return {
  -- Modern undotree with better preview
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { "<leader>tu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle Undo Tree" },
    },
  },
}