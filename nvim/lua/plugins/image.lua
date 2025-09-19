return {
	"3rd/image.nvim",
	-- so that it doesn't build the rock
	-- https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	build = false,
	opts = {
		processor = "magick_cli",
		backend = "kitty",
		integrations = {}, -- do whatever you want with image.nvim's integrations
		max_width = 100, -- tweak to preference
		max_height = 12, -- ^
		max_height_window_percentage = math.huge, -- this is necessary for a good experience
		max_width_window_percentage = math.huge,
		window_overlap_clear_enabled = true,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	},
}
