return {
  "ibhagwan/fzf-lua",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")
    
    fzf.setup({
      -- Global settings
      "default-title",
      fzf_opts = {
        ["--height"] = "40%",
        ["--layout"] = "reverse",
        ["--border"] = "rounded",
        ["--preview-window"] = "right:50%:wrap",
      },
      winopts = {
        height = 0.9,
        width = 0.9,
        preview = {
          border = "rounded",
          wrap = "nowrap",
          hidden = "nohidden",
          vertical = "down:45%",
          horizontal = "right:50%",
          layout = "flex",
          flip_columns = 120,
        },
      },
      files = {
        prompt = "Files❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g '!.git'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
      },
      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep For❯ ",
        multiprocess = true,
        git_icons = true,
        file_icons = true,
        color_icons = true,
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp -e",
      },
      buffers = {
        prompt = "Buffers❯ ",
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
      },
      oldfiles = {
        prompt = "History❯ ",
        cwd_only = false,
        stat_file = true,
        include_current_session = true,
      },
      quickfix = {
        file_icons = true,
        git_icons = false,
      },
      lsp = {
        prompt_postfix = "❯ ",
        cwd_only = false,
        async_or_timeout = 5000,
        file_icons = true,
        git_icons = false,
        color_icons = true,
        includeDeclaration = false,
        symbols = {
          async_or_timeout = true,
          symbol_style = 1,
          symbol_icons = {
            File = "󰈙",
            Module = "",
            Namespace = "󰌗",
            Package = "",
            Class = "󰌗",
            Method = "󰆧",
            Property = "",
            Field = "",
            Constructor = "",
            Enum = "󰒻",
            Interface = "󰕘",
            Function = "󰊕",
            Variable = "󰆧",
            Constant = "󰏿",
            String = "󰀬",
            Number = "󰎠",
            Boolean = "◩",
            Array = "󰅪",
            Object = "󰅩",
            Key = "󰌋",
            Null = "󰟢",
            EnumMember = "",
            Struct = "󰌗",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰊄",
          },
        },
      },
      git = {
        files = {
          prompt = "GitFiles❯ ",
          cmd = "git ls-files --exclude-standard",
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
        },
        status = {
          prompt = "GitStatus❯ ",
          cmd = "git status --porcelain=v1 -u",
          file_icons = true,
          git_icons = true,
          color_icons = true,
        },
        commits = {
          prompt = "Commits❯ ",
          cmd = "git log --color=always --pretty=format:'%C(yellow)%h%C(reset) %C(bold blue)%an%C(reset) %C(green)%cr%C(reset) %s'",
        },
        bcommits = {
          prompt = "BCommits❯ ",
          cmd = "git log --color=always --pretty=format:'%C(yellow)%h%C(reset) %C(bold blue)%an%C(reset) %C(green)%cr%C(reset) %s'",
        },
        branches = {
          prompt = "Branches❯ ",
          cmd = "git branch --all --color=always",
          preview = "git log --oneline --graph --date=short --color=always --pretty='format:%C(auto)%cd %h%d %s' {1}",
        },
        stash = {
          prompt = "Stash❯ ",
          cmd = "git --no-pager stash list",
        },
      },
    })

    -- Custom keymaps
    local map = vim.keymap.set
    
    -- File operations
    map("n", "<leader>ff", fzf.files, { desc = "Find files" })
    map("n", "<leader>fg", fzf.git_files, { desc = "Git files" })
    map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Find buffers" })
    
    -- Search operations
    map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
    map("n", "<leader>fW", fzf.grep_cWORD, { desc = "Grep WORD under cursor" })
    map("n", "<leader>fs", fzf.live_grep, { desc = "Live grep" })
    map("n", "<leader>fS", fzf.grep, { desc = "Grep" })
    map("v", "<leader>fs", fzf.grep_visual, { desc = "Grep visual selection" })
    
    -- LSP operations
    map("n", "<leader>flr", fzf.lsp_references, { desc = "LSP references" })
    map("n", "<leader>fld", fzf.lsp_definitions, { desc = "LSP definitions" })
    map("n", "<leader>fli", fzf.lsp_implementations, { desc = "LSP implementations" })
    map("n", "<leader>flt", fzf.lsp_typedefs, { desc = "LSP type definitions" })
    map("n", "<leader>fls", fzf.lsp_document_symbols, { desc = "Document symbols" })
    map("n", "<leader>flS", fzf.lsp_workspace_symbols, { desc = "Workspace symbols" })
    map("n", "<leader>fla", fzf.lsp_code_actions, { desc = "Code actions" })
    map("n", "<leader>flD", fzf.diagnostics_document, { desc = "Document diagnostics" })
    map("n", "<leader>flw", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
    
    -- Git operations
    map("n", "<leader>fgs", fzf.git_status, { desc = "Git status" })
    map("n", "<leader>fgc", fzf.git_commits, { desc = "Git commits" })
    map("n", "<leader>fgb", fzf.git_bcommits, { desc = "Git buffer commits" })
    map("n", "<leader>fgB", fzf.git_branches, { desc = "Git branches" })
    map("n", "<leader>fgh", fzf.git_stash, { desc = "Git stash" })
    
    -- Misc operations
    map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
    map("n", "<leader>fm", fzf.man_pages, { desc = "Man pages" })
    map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
    map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
    map("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix list" })
    map("n", "<leader>fl", fzf.loclist, { desc = "Location list" })
    map("n", "<leader>fj", fzf.jumps, { desc = "Jump list" })
    map("n", "<leader>fM", fzf.marks, { desc = "Marks" })
    map("n", "<leader>ft", fzf.tabs, { desc = "Tabs" })
    
    -- Keep your existing custom keymaps
    map("n", "<leader>fG", function()
      fzf.files({ cwd = "~" })
    end, { desc = "Find files globally (home directory)" })
    
    map("n", "<leader>fC", function()
      fzf.files({ cwd = "~/Developer" })
    end, { desc = "Find files in code projects" })
  end,
}