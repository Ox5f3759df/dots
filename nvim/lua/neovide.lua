-- Toggle Theme
-- Theme Switching
local font_size = "18"
local font_family = "JetBrainsMono Nerd Font Mono"
local linespace = 3
local transparency = 1.0
local lsp = require("lsp")

if vim.g.neovide then
	-- Functions
	-- font size helpers
	local increase_font = function()
		vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) + 0.1
	end
	local decrease_font = function()
		vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1) - 0.1
	end

	-- Neovide Settings
	vim.o.title = false
	vim.g.neovide_no_frame = true
	-- Set the titlestring to the current buffer's full path
	vim.o.titlestring = "%f"
	-- Fonts
	vim.o.guifont = font_family .. ":h" .. font_size
	vim.opt.linespace = linespace
	vim.g.neovide_input_ime = true
	vim.g.neovide_fullscreen = false
	vim.g.neovide_input_macos_option_key_is_meta = "both"
	vim.g.neovide_cursor_hack = true

	local map = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Keybindings
	-- cmd+a | Select all
	map("n", "<D-a>", "ggVG", opts)
	-- cmd+-= | set for normal/visual/visual-block in one call
	map({ "n", "v", "x" }, "<D-=>", increase_font, opts)
	map({ "n", "v", "x" }, "<D-->", decrease_font, opts)
	-- cmd+/ | vim-commentary
	map({ "n", "v", "x" }, "<D-/>", "gcc", { remap = true, silent = true })
	-- cmd+e | netrw / oil file explorer
	map({ "n", "v", "x" }, "<D-e>", ":lua require('oil').open_float()<CR>", opts)
	map("i", "<D-e>", "<C-o>:lua require('oil').open_float()<CR>", opts)
	-- cmd+shift+d | Go to definition
	map({ "n", "v", "x" }, "<D-S-d>", function()
		lsp.definition_split()
	end, opts)
	map("i", "<D-S-d>", function()
		lsp.definition_split()
	end, opts)
	-- cmd+f | grep
	map({ "n", "v", "x" }, "<D-f>", ":FzfLua grep<CR>", opts)
	map("i", "<D-f>", "<C-o>:FzfLua grep<CR>", opts)
	-- cmd+shift+f | Find in files
	map({ "n", "v", "x" }, "<D-S-f>", ":FzfLua live_grep<CR>", opts)
	map("i", "<D-S-f>", "<C-o>:FzfLua live_grep<CR>", opts)
	-- cmd+shift+h | Go back
	map({ "n", "v", "x" }, "<D-S-h>", "<C-o>", opts)
	map("i", "<D-S-h>", "<C-o><C-o>", opts)
	-- cmd+shift+l | Go back
	map({ "n", "v", "x" }, "<D-S-l>", "<C-i>", opts)
	map("i", "<D-S-h>", "<C-o><C-i>", opts)
	-- cmd+m | Messages
	map({ "n", "v", "x" }, "<D-m>", ":messages<CR>", opts)
	map("i", "<D-m>", "<C-o>:messages<CR>", opts)
	-- cmd+o | Open Buffers
	map({ "n", "v", "x" }, "<D-o>", ":FzfLua oldfiles<CR>", opts)
	map("i", "<D-o>", "<C-o>:FzfLua oldfiles<CR>", opts)
	-- cmd+p | File Picker
	map({ "n", "v", "x" }, "<D-p>", ":FzfLua files<CR>", opts)
	map("i", "<D-p>", "<C-o>:FzfLua files<CR>", opts)
	-- cmd+r | Recent files
	map({ "n", "v", "x" }, "<D-r>", ":AutoSession search<CR>", opts)
	map("i", "<D-r>", "<C-o>:AutoSession search<CR>", opts)
	-- cmd+s | Save
	map({ "n", "v", "x" }, "<D-s>", ":w!<CR>", opts)
	map("i", "<D-s>", "<C-o>:w!<CR>", opts)
	-- cmd+shift+s | Save Session
	map({ "n", "v", "x" }, "<D-S-s>", ":SessionSave<CR>", opts)
	map("i", "<D-S-s>", "<C-o>:SessionSave<CR>", opts)
	-- cmd+v | paste
	map({ "n", "v", "x" }, "<D-v>", '"+p', opts)
	map("i", "<D-v>", '<C-o>"+p', opts)
	-- cmd+w | Buffer Delete
	map({ "n", "v", "x" }, "<D-w>", ":bd!<CR>", opts)
	map("i", "<D-w>", "<C-o>:bd!<CR>", opts)
	-- cmd+z | Undo
	map({ "n", "v", "x" }, "<D-z>", "u", opts)
	map("i", "<D-z>", "<C-o>u", opts)
	-- cmd-shift+z | Redo
	map({ "n", "v", "x", "s" }, "<D-S-z>", "<cmd>redo<CR>", opts)
	map("i", "<D-S-z>", "<C-o><cmd>redo<CR>", opts)

	-- Window Movement
	local win_move = {
		["<D-h>"] = "<C-w>h",
		["<D-j>"] = "<C-w>j",
		["<D-k>"] = "<C-w>k",
		["<D-l>"] = "<C-w>l",
	}

	for k, v in pairs(win_move) do
		map({ "n", "v", "x", "s" }, k, v, opts)
		map("i", k, "<C-o>" .. v, opts)
	end

	vim.defer_fn(function()
		vim.cmd("NeovideFocus")
	end, 100)
end
