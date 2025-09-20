return {
	{
		"nvim-mini/mini.ai",
		opts = function(_, opts)
			opts = opts or {}
			local ai = require("mini.ai")
			opts.custom_textobjects = opts.custom_textobjects or {}
			-- Use Treesitter captures defined in your textobjects.scm for Jupyter code cells
			-- Maps: `ij` (inner cell) and `aj` (around cell)
			opts.custom_textobjects.j = ai.gen_spec.treesitter({
				a = "@code_cell.outer",
				i = "@code_cell.inner",
			}, {
				n_lines = 500,
			})
			return opts
		end,
		init = function()
			local function goto_code_cell(direction)
				local bufnr = 0
				if vim.bo[bufnr].filetype ~= "markdown" then
					return
				end
				local ok_parser, parser =
					pcall(vim.treesitter.get_parser, bufnr, "markdown")
				if not ok_parser or not parser then
					return
				end
				local ok_query, query =
					pcall(vim.treesitter.query.get, "markdown", "textobjects")
				if not ok_query or not query then
					return
				end

				local trees = parser:parse()
				if not trees or not trees[1] then
					return
				end
				local root = trees[1]:root()

				local targets = {}
				for id, node in query:iter_captures(root, bufnr, 0, -1) do
					local name = query.captures[(id or 0) + 1]
					if name == "code_cell.outer" then
						local srow, scol = node:range()
						targets[#targets + 1] = { srow, scol }
					end
				end
				if #targets == 0 then
					return
				end

				local cur = vim.api.nvim_win_get_cursor(0)
				local crow, ccol = cur[1] - 1, cur[2]
				local best
				if direction == "next" then
					for _, t in ipairs(targets) do
						local srow, scol = t[1], t[2]
						if srow > crow or (srow == crow and scol > ccol) then
							if
								not best
								or srow < best[1]
								or (srow == best[1] and scol < best[2])
							then
								best = { srow, scol }
							end
						end
					end
				else -- prev
					for _, t in ipairs(targets) do
						local srow, scol = t[1], t[2]
						if srow < crow or (srow == crow and scol < ccol) then
							if
								not best
								or srow > best[1]
								or (srow == best[1] and scol > best[2])
							then
								best = { srow, scol }
							end
						end
					end
				end

				if best then
					vim.api.nvim_win_set_cursor(0, { best[1] + 1, best[2] })
				end
			end

			vim.keymap.set("n", "]j", function()
				goto_code_cell("next")
			end, { desc = "Next code cell (Treesitter)" })
			vim.keymap.set("n", "[j", function()
				goto_code_cell("prev")
			end, { desc = "Previous code cell (Treesitter)" })
		end,
	},
}
