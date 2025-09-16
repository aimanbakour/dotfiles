-- Ensure fzf-lua drives vim.ui.select with a multi-line popup
return {
	{
		"ibhagwan/fzf-lua",
		-- Run after plugin loads to register ui.select backend
		config = function()
			local ok, fzf = pcall(require, "fzf-lua")
			if not ok then
				return
			end

			-- Force fzf to use the full terminal height of the floating window
			-- This avoids one-line lists when FZF_DEFAULT_OPTS sets --height
			fzf.register_ui_select({
				-- Use a reasonable default size; fzf renders within this window
				winopts = {
					height = 0.35, -- percentage of Neovim screen
					width = 0.50,
				},
				fzf_opts = {
					["--no-height"] = true, -- ignore any --height from env/defaults
					-- ["--layout"] = "reverse-list",
				},
				-- no preview for simple selection menus
				previewer = false,
			})
		end,
	},
}
