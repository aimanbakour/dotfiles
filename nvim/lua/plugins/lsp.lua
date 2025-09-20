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
