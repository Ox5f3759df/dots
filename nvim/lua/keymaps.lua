local M = {}

local utils = require("utils")
local kmap = vim.keymap.set
local kopts = function(desc)
	return { noremap = true, silent = true, desc = desc or "" }
end

local function setup_keymaps()
	-- Function Keys
	-- Note: Do not map F2 as it is bound to snippets
	kmap("n", "<F1>", ":FzfLua files<CR>", kopts("FzfLua: liles"))
	kmap("n", "<F3>", ":FzfLua commands<CR>", kopts("FzfLua: commands"))
	kmap("n", "<F4>", ":FzfLua grep<CR>", kopts("FzfLua: grep"))
	kmap("n", "<F5>", ":FzfLua live_grep<CR>", kopts("FzfLua: live_grep"))
	kmap("n", "<F6>", ":bd!<CR>", kopts("Windows: close all"))
	kmap("n", "<F7>", ":qa!<CR>", kopts("Windows: Force Close"))
	kmap("n", "<F8>", ":redo<CR>", kopts("Redo"))
	kmap("n", "<F9>", ":FzfLua oldfiles<CR>", kopts("FzfLua: oldfiles"))
	kmap("n", "<F10>", ":FzfLua colorschemes<CR>", kopts("FzfLua: colorschemes"))
	kmap("n", "<F11>", ":lua require('oil').open_float()<CR>", kopts("Oil"))
	kmap("n", "<F12>", ":messages<CR>", kopts("Messages"))

	-- Space
	kmap("n", "<space>e", ":lua require('oil').open_float()<CR>", kopts("Oil"))
	kmap("n", "<space>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { bufnr = 0 })end, kopts("Toggle LSP Inlay Hints"))
	kmap("n", "<space>m", ":Mason<CR>", kopts("Mason"))
	kmap("n", "<space>n", ":noh<CR>", kopts(":noh"))
	kmap("n", "<space>l", ":LspInfo<CR>", kopts("LspInfo"))
	kmap("n", "<space>L", function()
		utils.load_ft_modules(true)
	end, kopts("Nvim: Reload ft/* modules"))
	kmap("n", "<space>r", ":FzfLua registers<CR>", kopts("Registers"))
	kmap("n", "<space>sd", ":AutoSession deletePicker<CR>", kopts("Autosession: delete"))
	kmap("n", "<space>ss", ":AutoSession search<CR>", kopts("Autosession: search"))
	kmap("n", "<space>T", ":TSInstallInfo<CR>", kopts("TSInstallInfo"))
	kmap("n", "<space>u", ":lua vim.pack.update()<CR>", kopts("Vim Pack: Update"))

	-- Leader
	kmap("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>", kopts("LSP: Format File"))
	kmap("n", "<leader>n", ":noh<CR>", kopts(":noh"))
	kmap("n", "<leader>o", "gx", kopts("Open Links"))

	-- E
	kmap("n", "e=", "10<C-w>>", kopts("Editor: Resize >"))
	kmap("n", "e-", "10<C-w><", kopts("Editor: Resize <"))
	kmap("n", "e", "<C-w>", kopts("Wincmd"))
	kmap("n", "eL", ":vsplit | wincmd l | b# | close#<CR>", kopts("Editor: Split right"))
	kmap("n", "e+", "10<C-w>=", kopts("Editor: Resize up"))
	kmap("n", "e_", "10<C-w>-", kopts("Editor: Resize down"))
	kmap("n", "e[", ":bp<CR>", kopts("Editor: Next Tab"))
	kmap("n", "e]", ":bn<CR>", kopts("Editor: Prev Tab"))
	kmap("n", "e<BS>", function()
		utils.close_other_buffers()
	end, kopts("Editor: Close all buffers except current"))

	-- H
	kmap("n", "H", ":bp<CR>", kopts("Editor: Next Tab"))

	-- L
	kmap("n", "L", ":bn<CR>", kopts("Editor: Prev Tab"))

	-- T
	kmap("n", "ts", function()
		utils.trim_trailing_whitespaces()
	end, kopts("Trim: Trailing Whitespaces"))

	-- Y
	kmap("x", "Y", '"+yy', kopts("Copy: Yank to Global Clipboard"))

	-- Rest
	kmap("n", ";", "<C-d>", kopts("Pagedown"))
	kmap("n", "'", "<C-u>", kopts("Pageup"))
	kmap("n", "-", "#", kopts("Select word and prev occurence"))
	kmap("n", "=", "*", kopts("Select word and next occurence"))
	kmap("n", "?", ":FzfLua grep_cword<CR>", kopts("Search word under cursor in project"))
end

local function setup_plugin_mini_keymaps()
	-- Clues
	local triggers = {}
	local add_triggers = function(modes, key)
		for _, mode in ipairs(modes) do
			table.insert(triggers, { mode = mode, keys = key })
		end
	end

	add_triggers({ "n", "x" }, "<leader>")
	add_triggers({ "n", "v", "x" }, "<space>")
	add_triggers({ "n", "v", "x" }, "<C-a>")
	add_triggers({ "n", "v", "x" }, "a")
	add_triggers({ "n", "v", "x" }, "e")
	add_triggers({ "n", "v", "x" }, "g")
	add_triggers({ "n", "v", "x" }, "m")
	add_triggers({ "n", "v", "x" }, "s")
	add_triggers({ "n", "v", "x" }, "t")
	require("mini.clue").setup({ triggers = triggers })
end

M.setup = function(opts)
	opts = opts or {}
	setup_keymaps()
	setup_plugin_mini_keymaps()
end

return M
