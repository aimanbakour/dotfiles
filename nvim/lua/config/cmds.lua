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

-- Begin Molten
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

-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
	vim.schedule(function()
		local kernels = vim.fn.MoltenAvailableKernels()
		local try_kernel_name = function()
			local metadata =
				vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
			return metadata.kernelspec.name
		end
		local ok, kernel_name = pcall(try_kernel_name)
		if not ok or not vim.tbl_contains(kernels, kernel_name) then
			kernel_name = nil
			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
			if venv ~= nil then
				kernel_name = string.match(venv, "/.+/(.+)")
			end
		end
		if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
			vim.cmd(("MoltenInit %s"):format(kernel_name))
		end
		vim.cmd("MoltenImportOutput")
	end)
end

-- automatically import output chunks from a jupyter notebook
vim.api.nvim_create_autocmd("BufAdd", {
	pattern = { "*.ipynb" },
	callback = imb,
})

-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.ipynb" },
	callback = function(e)
		if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
			imb(e)
		end
	end,
})

-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
	vim.schedule(function()
		local kernels = vim.fn.MoltenAvailableKernels()
		local try_kernel_name = function()
			local metadata =
				vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
			return metadata.kernelspec.name
		end
		local ok, kernel_name = pcall(try_kernel_name)
		if not ok or not vim.tbl_contains(kernels, kernel_name) then
			kernel_name = nil
			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
			if venv ~= nil then
				kernel_name = string.match(venv, "/.+/(.+)")
			end
		end
		if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
			vim.cmd(("MoltenInit %s"):format(kernel_name))
		end
		vim.cmd("MoltenImportOutput")
	end)
end

-- automatically import output chunks from a jupyter notebook
vim.api.nvim_create_autocmd("BufAdd", {
	pattern = { "*.ipynb" },
	callback = imb,
})

-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.ipynb" },
	callback = function(e)
		if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
			imb(e)
		end
	end,
})

-- change the configuration when editing a python file
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.py",
	callback = function(e)
		if string.match(e.file, ".otter.") then
			return
		end
		if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
			vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
			vim.fn.MoltenUpdateOption("virt_text_output", false)
		else
			vim.g.molten_virt_lines_off_by_1 = false
			vim.g.molten_virt_text_output = false
		end
	end,
})

-- Undo those config changes when we go back to a markdown or quarto file
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.qmd", "*.md", "*.ipynb" },
	callback = function(e)
		if string.match(e.file, ".otter.") then
			return
		end
		if require("molten.status").initialized() == "Molten" then
			vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
			vim.fn.MoltenUpdateOption("virt_text_output", true)
		else
			vim.g.molten_virt_lines_off_by_1 = true
			vim.g.molten_virt_text_output = true
		end
	end,
})
