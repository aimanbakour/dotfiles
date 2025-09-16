local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- stylua: ignore start
local todo = s("todo", fmt("-- TODO({}): {}", { i(1, "me"), i(2) }))

-- stylua: ignore end

-- return { todo, stk, view }
