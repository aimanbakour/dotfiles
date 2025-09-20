return {
	"benlubas/molten-nvim",
	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	build = ":UpdateRemotePlugins",
	keys = {
		{
			"<leader>mi",
			mode = { "n" },
			"<cmd>MoltenInit<cr>",
			desc = "Init Molten",
		},
		{
			"<leader>me",
			mode = { "n" },
			"<cmd>MoltenEvaluateOperator<cr>",
			desc = "Evaluate operator",
			silent = true,
		},
		{
			"<leader>mos",
			mode = { "n" },
			"<cmd>noautocmd MoltenEnterOutput<cr>",
			desc = "Open output window",
			silent = true,
		},
		{
			"<leader>mrr",
			mode = { "n" },
			"<cmd>MoltenReevaluateCell<cr>",
			desc = "Re-eval cell",
			silent = true,
		},
		{
			"<leader>mr",
			mode = { "v" },
			":<C-u>MoltenEvaluateVisual<CR>gv",
			desc = "Execute visual selection",
			silent = true,
		},
		{
			"<leader>moh",
			mode = { "n" },
			"<cmd>MoltenHideOutput<cr>",
			desc = "Close output window",
			silent = true,
		},
		{
			"<leader>md",
			mode = { "n" },
			"<cmd>MoltenDelete<cr>",
			desc = "Delete Molten cell",
			silent = true,
		},
		-- {
		-- 	"<leader>mpi",
		-- 	mode = { "n" },
		-- 	function()
		-- 		local venv = os.getenv("VIRTUAL_ENV")
		-- 		if not venv then
		-- 			vim.notify(
		-- 				"Activate python env first",
		-- 				vim.logs.levels.WARNING
		-- 			)
		-- 			return
		-- 		else
		-- 			vim.cmd("MoltenInit python3")
		-- 		end
		-- 	end,
		-- 	desc = "Init Molten with a python kernel",
		-- },
	},
	init = function()
		-- I find auto open annoying, keep in mind setting this option will
		-- require setting
		-- a keybind for `:noautocmd MoltenEnterOutput` to open the output again
		vim.g.molten_auto_open_output = false

		vim.g.molten_image_provider = "image.nvim"

		-- optional, I like wrapping. works for virt text and the output window
		vim.g.molten_wrap_output = true

		-- Output as virtual text. Allows outputs to always be shown.
		vim.g.molten_virt_text_output = true

		-- this will make it so the output shows up below the \`\`\` cell delimiter
		vim.g.molten_virt_lines_off_by_1 = true
	end,
}
