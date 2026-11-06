-- Copilot comes from the LazyVim extra (lazyvim.json); this only sets keymaps.
-- The extra leaves accept to blink, but blink.lua overrides its keymaps.
return {
	"zbirenbaum/copilot.lua",
	opts = {
		suggestion = {
			keymap = {
				-- most Alt keys are taken by AeroSpace, C-j/k/l/g by luasnip
				accept = "<M-y>",
				accept_word = "<M-m>",
				dismiss = "<M-n>",
				next = "<M-]>",
				prev = "<M-[>",
			},
		},
	},
}
