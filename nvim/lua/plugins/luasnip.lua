return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	build = "make install_jsregexp",
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
	config = function(_, opts)
		local ls = require("luasnip")
		ls.config.setup(opts)

		local paths = { vim.fn.stdpath("config") .. "/lua/snippets" }
		require("luasnip.loaders.from_lua").lazy_load({ paths = paths })

		-- Keymaps (simple + quiet)
		local map = vim.keymap.set
		map({ "i", "s" }, "<C-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true, desc = "LuaSnip expand/jump" })

		map({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true, desc = "LuaSnip jump back" })

		map("i", "<C-l>", function()
			if ls.choice_active() then
				ls.change_choice(1)
			end
		end, { silent = true, desc = "LuaSnip next choice" })
		-- map("i", "<C-l>", function()
		-- 	ls.extras.select_choice()
		-- end, { silent = true, desc = "LuaSnip next choice" })
		map({ "i", "s" }, "<C-g>", function()
			if ls.choice_active() then
				require("luasnip.extras.select_choice")()
			end
		end, { desc = "LuaSnip choice menu" })
	end,
}
