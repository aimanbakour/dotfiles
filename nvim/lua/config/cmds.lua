local uv = vim.uv or vim.loop

local function reload_snippets()
	local ok, loader = pcall(require, "luasnip.loaders.from_lua")
	if ok then
		loader.load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })
		vim.notify("Snippets reloaded", vim.log.levels.INFO)
	end
end

vim.api.nvim_create_user_command("Restart", function()
	local t0 = uv.hrtime()

	-- 1) Unload ONLY your own modules so requiring them re-runs
	local prefixes = { "^config", "^pluging", "^snippets" }
	for k in pairs(package.loaded) do
		for _, p in ipairs(prefixes) do
			if k:match(p) then
				package.loaded[k] = nil
				break
			end
		end
	end

	-- same as :Lazy reload
	pcall(function()
		require("lazy").reload({})
	end)

	pcall(reload_snippets)

	vim.notify(
		string.format("Restarted (%.0f ms)", (uv.hrtime() - t0) / 1e6),
		vim.log.levels.INFO
	)
end, {})

vim.api.nvim_create_user_command("ReloadSnippets", reload_snippets, {})

local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
	local path = filename .. ".ipynb"
	local file = io.open(path, "w")
	if file then
		file:write(default_notebook)
		file:close()
		vim.cmd("edit " .. path)
	else
		print("Error: Could not open new notebook file for writing.")
	end
end

vim.api.nvim_create_user_command("NewNotebook", function(opts)
	new_notebook(opts.args)
end, {
	nargs = 1,
	complete = "file",
})
