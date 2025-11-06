local M = {}

M.commands = {
	"python ${file}",
}
M.template_map = {
	[[print("$0")]],
	[[print(f"Variable $0: {str($0)}")]],
	[[import pdb; pdb.set_trace() # FIXME]],
}

local ftpath = "ft/python"
local lang = "Python"
local autocmd_patterns = { "python" }
local commands = require("commands")
local templates = require("templates")
local kmap = vim.keymap.set
local kopts = function(x)
	return { noremap = true, silent = true, desc = x or "" }
end

M.autocommands = function()
	local langGroup = vim.api.nvim_create_augroup(lang .. "Group", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = langGroup,
		pattern = autocmd_patterns,
		callback = function(args)
			vim.api.nvim_create_autocmd("BufEnter", {
				buffer = args.buf,
				callback = function()
					-- Enter Filetype commands here
					kmap({ "n", "v", "x" }, "<F2>", function()
						templates.insert_snippet(require(ftpath).template_map)
					end, kopts("Snippets: Insert"))
					kmap("i", "<F2>", function()
						templates.insert_snippet(require(ftpath).template_map, true)
					end, kopts("Snippets: Insert"))
					kmap("n", commands.config.keys.select_cmd, function()
						commands.fzf_command_picker(require(ftpath).commands)
					end, kopts("Cmds: Select and Run"))
					kmap("n", commands.config.keys.select_watchman_cmd, function()
						commands.watch_pick_and_run(require(ftpath).commands)
					end, kopts("Cmds: Select Watch and Run"))
					kmap("n", commands.config.keys.run_single, function()
						commands.run_in_terminal_single(require(ftpath).commands[commands.config.run_single_idx])
					end, kopts("Cmds: Run/Watch Default"))
					kmap("n", "<leader>e", ":VenvSelect<CR>", kopts("VenvSelect: Choose Python"))
				end,
			})
			-- Exit
			vim.api.nvim_create_autocmd("BufLeave", {
				buffer = args.buf,
				callback = function() end,
			})
			-- Save
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function() end,
			})
		end,
	})
end
return M
