-- https://github.com/benlubas/molten-nvim/blob/main/docs/Notebook-Setup.md
return {
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			lspFeatures = {
				enabled = true,
				chunks = "all",
				languages = { "r", "python", "julia", "bash", "html" },
				diagnostics = {
					enabled = true,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = true,
				default_method = "molten",
			},
		},
		config = function(_, opts)
			require("quarto").setup(opts)

			-- runner keymaps
			local runner = require("quarto.runner")
			vim.keymap.set(
				"n",
				"<leader>rc",
				runner.run_cell,
				{ desc = "run cell", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>ra",
				runner.run_above,
				{ desc = "run cell and above", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>rA",
				runner.run_all,
				{ desc = "run all cells", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>rl",
				runner.run_line,
				{ desc = "run line", silent = true }
			)
			vim.keymap.set(
				"v",
				"<leader>r",
				runner.run_range,
				{ desc = "run visual range", silent = true }
			)
			vim.keymap.set("n", "<leader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages", silent = true })
		end,
	},
	{ -- directly open ipynb files as quarto docuements
		-- and convert back behind the scenes
		"GCBallesteros/jupytext.nvim",
		opts = {
			style = "markdown",
			output_extension = "md",
			force_ft = "markdown",
		},
	},
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"nvimtools/hydra.nvim",
		config = function()
			local ok_hydra, hydra = pcall(require, "hydra")
			if not ok_hydra then
				return
			end

			local function keys(str)
				return function()
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes(str, true, false, true),
						"m",
						true
					)
				end
			end

			hydra({
				name = "QuartoNavigator",
				hint = table.concat({
					"_j_/_k_: move down/up  _r_: run cell",
					"_l_: run line  _R_: run above",
					"^^     _<esc>_/_q_: exit",
				}, "\n"),
				config = {
					color = "pink",
					invoke_on_body = true,
					hint = {
						float_opts = { border = "rounded" },
						offset = 0,
					},
				},
				mode = { "n" },
				body = "<leader>h",
				heads = {
					{ "j", keys("]j") },
					{ "k", keys("[j") },
					{ "r", ":QuartoSend<CR>" },
					{ "l", ":QuartoSendLine<CR>" },
					{ "R", ":QuartoSendAbove<CR>" },
					{ "<esc>", nil, { exit = true } },
					{ "q", nil, { exit = true } },
				},
			})
		end,
	},
}
