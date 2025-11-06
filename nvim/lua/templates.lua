local M = {}

local fzflua = require("fzf-lua")
local utils = require("utils")

local function insert_snippet_at_cursor(snippet, started_insert_mode)
	started_insert_mode = started_insert_mode or false
	local buf = 0
	local win = 0
	local cur = vim.api.nvim_win_get_cursor(win)
	local row, col = cur[1], cur[2]
	if started_insert_mode then
		col = col + 1
	end
	local s_lines = vim.split(snippet, "\n", { plain = true })

	-- find all $n markers
	local markers = {}
	for _, line in ipairs(s_lines) do
		for num in line:gmatch("%$(%d+)") do
			markers[tonumber(num)] = true
		end
	end
	-- sort keys ascending
	local sorted_keys = {}
	for k in pairs(markers) do
		table.insert(sorted_keys, k)
	end
	table.sort(sorted_keys)
	local replacements = {}

	-- process $NUM inputs and ask user for replacement
	local function process_input(i)
		if i > #sorted_keys then
			for li, line in ipairs(s_lines) do
				line = line:gsub("%$(%d+)", function(num)
					return replacements[tonumber(num)] or ""
				end)
				s_lines[li] = line
			end

			local curline = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
			local before = curline:sub(1, col)
			local after = curline:sub(col + 1, -1)

			local new_lines = {}
			if #s_lines == 1 then
				new_lines[1] = before .. s_lines[1] .. after
			else
				new_lines[1] = before .. s_lines[1]
				for j = 2, #s_lines - 1 do
					new_lines[j] = s_lines[j]
				end
				new_lines[#s_lines] = s_lines[#s_lines] .. after
			end

			vim.api.nvim_buf_set_lines(buf, row - 1, row, false, new_lines)

			if replacements[0] then
				local first_line = new_lines[1]
				local pos = first_line:find(replacements[0], 1, true)
				if pos then
					vim.api.nvim_win_set_cursor(win, { row, pos - 1 })
					return
				end
			end
			vim.api.nvim_win_set_cursor(win, { row - 1 + #new_lines, #new_lines[#new_lines] })
			return
		end

		local n = sorted_keys[i]
		-- ask user for each $num replacement
		vim.ui.input({ prompt = "Enter value for $" .. n .. ": " }, function(input)
			replacements[n] = input or ""
			process_input(i + 1)
		end)
	end
	-- start processing inputs
	process_input(1)
end

M.insert_snippet = function(snippet_table, started_insert_mode)
	started_insert_mode = started_insert_mode or false
	snippet_table = snippet_table or nil
	if snippet_table ~= nil then
		local opts = {
			prompt = "Select Snippet ",
			winopts = {
				width = 0.6,
				row = 0.4,
			},
			actions = {
				["default"] = function(selected)
					local selected_snippet = selected[1]
					selected_snippet = utils.expand_placeholders(selected_snippet)
					insert_snippet_at_cursor(selected_snippet, started_insert_mode)
				end,
			},
			on_complete = function()
				vim.cmd("startinsert") -- go back to insert mode
			end,
		}
		fzflua.fzf_exec(snippet_table, opts)
	end
end

M.setup = function() end

return M
