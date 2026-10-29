return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- VimTeX configuration goes here, e.g.
		vim.g.vimtex_view_method = "zathura"
		-- vim.g.vimtex_compiler_method = "tectonic"
		-- vim.g.vimtex_compiler_tectonic = {
		-- 	options = { "--synctex", "--keep-logs" },
		-- 	out_dir = "build",
		-- }
		vim.g.vimtex_server_enabled = 1 -- IMPORTANT for zathura+nvr
		-- vim.g.vimtex_view_zathura_options = [[--fork]]
	end,
}
