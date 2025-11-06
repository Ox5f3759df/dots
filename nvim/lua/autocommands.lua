local M = {}
local utils = require("utils")

M.setup = function(opts)
	-- Load ft/*
	utils.load_ft_modules()

	-- Update wezterm title on enter
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		callback = function(event)
			local title = "vim"
			if event.file ~= "" then
				title = string.format("vim: %s", vim.fs.basename(event.file))
			end

			vim.fn.system({ "wezterm", "cli", "set-tab-title", title })
		end,
	})
	vim.api.nvim_create_autocmd({ "VimLeave" }, {
		callback = function()
			-- Setting title to empty string causes wezterm to revert to its
			-- default behavior of setting the tab title automatically
			vim.fn.system({ "wezterm", "cli", "set-tab-title", "" })
		end,
	})
	vim.api.nvim_create_augroup("AutoReloadOnCursor", { clear = true })

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = "AutoReloadOnCursor",
		pattern = "*",
		command = "checktime",
	})

	-- Restore cursor position when reopening files
	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*",
		callback = function()
			local mark = vim.api.nvim_buf_get_mark(0, '"')
			local lcount = vim.api.nvim_buf_line_count(0)
			if mark[1] > 0 and mark[1] <= lcount then
				pcall(vim.api.nvim_win_set_cursor, 0, mark)
			end
		end,
	})
end

return M
