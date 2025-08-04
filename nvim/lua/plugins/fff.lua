return {
  "dmtrKovalenko/fff.nvim",
  build = "rustup run nightly cargo build --release",
  -- or if using nixos
  -- build = "nix run .#release",
  opts = {
    -- pass configuration options here
  },
  keys = {
    {
      "ff", 
      function()
        require("fff").find_files() -- or find_in_git_root() for git files
      end,
      desc = "Open file picker",
    },
  },
}