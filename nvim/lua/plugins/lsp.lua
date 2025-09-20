return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				sourcekit = {
					cmd = { "/usr/bin/sourcekit-lsp" },
					capabilities = {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					},
				},
				-- Jupyter notebooks, unused expression at the bottom of a cell
				-- as a way of printing the value
				pyright = {
					settings = {
						python = {
							analysis = {
								diagnosticSeverityOverrides = {
									reportUnusedExpression = "none",
								},
							},
						},
					},
				},
			},
		},
	},
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {},
	},
}
