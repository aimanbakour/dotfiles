return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			swift = { "swift_format" },
			nix = { "alejandra" },
		},
		formatters = {
			ruff_format = {
				prepend_args = { "--line-length", "80" },
			},
			prettier = {
				prepend_args = { "--print-width", "80" },
			},
			stylua = {
				prepend_args = { "--column-width", "80" },
			},
			swift_format = {
				command = "/opt/homebrew/bin/swiftformat",
				args = {
					"--max-width",
					"80",
					"--swift-version",
					"6.2",
					"stdin",
				},
				stdin = true,
			},
		},
	},
}
