return {
	"saghen/blink.cmp",
	dependencies = {
		{ "rafamadriz/friendly-snippets", enabled = false },
	},
	opts = function(_, opts)
		opts.completion = {
			menu = { auto_show = false },
			ghost_text = { enabled = false },
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
		}
		opts.snippets = { preset = "luasnip" }

		opts.keymap = {
			preset = "default",
			["<C-space>"] = {
				function(cmp)
					cmp.show({ providers = { "lsp", "path", "buffer" } })
				end,
			},
			["<M-space>"] = {
				function(cmp)
					cmp.show({ providers = { "snippets" } })
				end,
			},
		}
		opts.sources = {
			per_filetype = {
				markdown = {},
			},
			transform_items = function(_, items)
				-- filter out LSP "Text" suggestions
				return vim.tbl_filter(function(item)
					return item.kind ~= vim.lsp.protocol.CompletionItemKind.Text
				end, items)
			end,
		}

		return opts
	end,
}
