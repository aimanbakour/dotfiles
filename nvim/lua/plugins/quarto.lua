return {
    {
        "quarto-dev/quarto-nvim",
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
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
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
			vim.keymap.set("n", "<localleader>RA", function()
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
            -- custom_language_formatting = {
            -- 	python = {
            -- 		extension = "qmd",
            -- 		style = "quarto",
            -- 		force_ft = "quarto",
            -- 	},
            -- 	r = {
            -- 		extension = "qmd",
            -- 		style = "quarto",
            -- 		force_ft = "quarto",
            -- 	},
            -- },
        },
    },
	{
		{
			"jmbuhr/otter.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			opts = {},
		},
	},
}
