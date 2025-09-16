local ls = require("luasnip")
local s, t, i = ls.snippet, ls.text_node, ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s("python", fmt("-- TODO({}): {}", { i(1, "me"), i(2) })),
}
