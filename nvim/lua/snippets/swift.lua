local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local filename_no_ext = function()
	return vim.fn.expand("%:t:r")
end

-- stylua: ignore start
local view =  s("view", fmt([[
import SwiftUI

struct {}: View {{
    var body: some View {{
        {}
    }}
}}

#Preview {{
    {}()
}}
]], {
    f(filename_no_ext), -- struct name
    i(0, { 'Text("Hello, World!")', "    .padding()" }),
    f(filename_no_ext), -- preview call
  }))

local stack = s("stk", fmt([[
{}({}) {{
    {}
}}
]], {
    c(1, {t("VStack"), t("ZStack"), t("HStack")}),
    i(0),
    i(2, { 'Text("Hello")', "    .padding()" })
}))

local state = s("state", fmt([[
@State private var {} = {}
]], { i(1, "name"), i(0, '""')}))

-- stylua: ignore end

return { view, stack, state }
