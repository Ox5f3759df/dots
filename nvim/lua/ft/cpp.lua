local M = {}

M.commands = {
	"clear; mkdir -p .bins; bear -- g++ -std=c++2c -g -o .bins/cpp.out ${file} && .bins/cpp.out",
}
M.template_map = {
	[[std::cout << "$0" << '\n'; // FIXME]],
	[[std::cout << "Variable $0: " << $0 << '\n'; // FIXME]],
	[[std::cout << "(" << __func__ << ") " << "file: " << __FILE__ << ":" << __LINE__ << '\n'; // FIXME]],
	[[#define LOG() std::cout << "(" << __func__ << ") file: " << __FILE__ << ":" << __LINE__ << '\n';]],
}

local ftpath = "ft/cpp"
local lang = "Cpp"
local autocmd_patterns = { "cpp" }
local commands = require("commands")
local templates = require("templates")

M.autocommands = function()
	local langGroup = vim.api.nvim_create_augroup(lang .. "Group", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = langGroup,
		pattern = autocmd_patterns,
		callback = function(args)
			vim.api.nvim_create_autocmd("BufEnter", {
				buffer = args.buf,
				callback = function()
					-- Filetype bindings here
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
