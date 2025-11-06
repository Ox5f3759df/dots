local M = {}

M.close_other_buffers = function()
	local current = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

-----------------------------------------------------------------------------------------
-- Placeholders
-- ${cwd}                                     -- fullpath to current working directory
-- ${file}                                    -- relative path to file
-- ${dir}                                     -- relative path to parent directory of current file
-- ${basename}                                -- current filename with extension
-- ${basenameNoExt}                           -- current filename without extension
-- ${fullpath}                                -- fullpath of current file
-- ${fulldir}                                 -- fullpath to parent directory of current file
-----------------------------------------------------------------------------------------
M.expand_placeholders = function(cmd)
	if cmd ~= nil then
		local cwd = vim.fn.getcwd() -- current working directory
		local full = vim.fn.expand("%:p") -- full path
		local filename = vim.fn.expand("%:t") -- file name with ext
		local basename = vim.fn.expand("%:t:r") -- filename without ext
		local rel = vim.fn.fnamemodify(full, ":.") -- relative to cwd
		local fulldir = vim.fn.expand("%:p:h") -- full path to parent directory
		local rel_dir = vim.fn.fnamemodify(fulldir, ":.") -- parent directory relative to cwd

		cmd = cmd:gsub("%${cwd}", vim.fn.shellescape(cwd))
		cmd = cmd:gsub("%${file}", vim.fn.shellescape(rel))
		cmd = cmd:gsub("%${basename}", vim.fn.shellescape(filename))
		cmd = cmd:gsub("%${basenameNoExt}", vim.fn.shellescape(basename))
		cmd = cmd:gsub("%${fullpath}", vim.fn.shellescape(full))
		cmd = cmd:gsub("%${fulldir}", vim.fn.shellescape(fulldir))
		cmd = cmd:gsub("%${dir}", vim.fn.shellescape(rel_dir))
	else
		cmd = ""
	end
	return cmd
end

M.load_ft_modules = function(reload_themes)
	reload_themes = reload_themes or false
	-- Use plenary reload in order to see dynamic changes to ft/* when run
	-- dynamically while in neovim
	local reload = require("plenary.reload").reload_module

	-- Find and enable all FT autocommands
	local ft_dir = vim.fn.stdpath("config") .. "/lua/ft"
	local exclude_mod_name = "ft/_template"
	local files = vim.fn.glob(ft_dir .. "/*.lua", false, true)
	for _, file in ipairs(files) do
		local mod_name = file:match("lua/(.*)%.lua$")
		if mod_name and mod_name ~= exclude_mod_name then
			reload(mod_name)
			local module = require(mod_name)
			module.autocommands(module.template_map)
			-- vim.notify(vim.inspect(module))
		end
	end
	vim.notify("Loaded ft/*")
	if reload_themes then
		reload("theme")
		local module = require("theme")
		module.setup({})
	end
end

M.trim_trailing_whitespaces = function()
	if not vim.o.binary and vim.o.filetype ~= "diff" then
		local current_view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(current_view)
	end
end

return M
