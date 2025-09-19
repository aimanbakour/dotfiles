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
			desc = "Init Molten",
		},
		{
			"<leader>mpi",
			mode = { "n" },
            function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv ~= nil then
                -- vim.notify("Activate python env first", vim.logs.)
            else
                vim.cmd("MoltenInit python3")
            end,
			desc = "Init Molten with a python kernel",
		},
	},
	init = function()
		-- this is an example, not a default. Please see the readme for more configuration options
		vim.g.molten_output_win_max_height = 12
	end,
}
