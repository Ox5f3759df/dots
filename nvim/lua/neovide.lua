-- Toggle Theme
-- Theme Switching
local font_size = "18"
local font_family = "JetBrainsMono Nerd Font Mono"
local linespace = 3
local transparency = 1.0
local lsp = require('lsp')

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
  vim.g.neovide_input_macos_option_key_is_meta = 'both'
  vim.g.neovide_cursor_hack = true


  -- Keybindings
  -- cmd+a | Select all
  vim.keymap.set("n", "<D-a>", "ggVG", { noremap = true, silent = true })

  -- cmd+-= | set for normal/visual/visual-block in one call
  vim.keymap.set({ "n", "v", "x" }, "<D-=>", increase_font, { noremap = true, silent = true })
  vim.keymap.set({ "n", "v", "x" }, "<D-->", decrease_font, { noremap = true, silent = true })

  -- cmd+/ | vim-commentary
  vim.keymap.set({ "n", "v", "x" }, "<D-/>", 'gcc', { remap = true, silent = true })

  -- cmd+e | netrw / oil file explorer
  vim.keymap.set({ "n", "v", "x" }, "<D-e>", ":lua require('oil').open_float()<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-e>", "<C-o>:lua require('oil').open_float()<CR>",  { noremap = true, silent = true })

  -- cmd+shift+d | Go to definition
  vim.keymap.set({ "n", "v", "x" }, "<D-S-d>", function() lsp.definition_split() end,  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-d>", function() lsp.definition_split() end,  { noremap = true, silent = true })

  -- cmd+f | grep
  vim.keymap.set({ "n", "v", "x" }, "<D-f>", ":FzfLua grep<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-f>", "<C-o>:FzfLua grep<CR>",  { noremap = true, silent = true })

  -- cmd+shift+f | Find in files
  vim.keymap.set({ "n", "v", "x" }, "<D-S-f>", ":FzfLua live_grep<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-f>", "<C-o>:FzfLua live_grep<CR>",  { noremap = true, silent = true })

  -- cmd+shift+h | Go back
  vim.keymap.set({ "n", "v", "x" }, "<D-S-h>", "<C-o>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-h>", "<C-o><C-o>",  { noremap = true, silent = true })

  -- cmd+shift+l | Go back
  vim.keymap.set({ "n", "v", "x" }, "<D-S-l>", "<C-i>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-h>", "<C-o><C-i>",  { noremap = true, silent = true })

  -- cmd+m | Messages
  vim.keymap.set({ "n", "v", "x" }, "<D-m>", ":messages<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-m>", "<C-o>:messages<CR>",  { noremap = true, silent = true })

  -- cmd+o | Open Buffers
  vim.keymap.set({ "n", "v", "x" }, "<D-o>", ":FzfLua oldfiles<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-o>", "<C-o>:FzfLua oldfiles<CR>",  { noremap = true, silent = true })

  -- cmd+p | File Picker
  vim.keymap.set({ "n", "v", "x" }, "<D-p>", ":FzfLua files<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-p>", "<C-o>:FzfLua files<CR>",  { noremap = true, silent = true })

  -- cmd+r | Recent files
  vim.keymap.set({ "n", "v", "x" }, "<D-r>", ":AutoSession search<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-r>", "<C-o>:AutoSession search<CR>",  { noremap = true, silent = true })

  -- cmd+s | Save
  vim.keymap.set({ "n", "v", "x" }, "<D-s>", ":w!<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-s>", "<C-o>:w!<CR>",  { noremap = true, silent = true })

  -- cmd+shift+s | Save Session
  vim.keymap.set({ "n", "v", "x" }, "<D-S-s>", ":SessionSave<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-s>", "<C-o>:SessionSave<CR>",  { noremap = true, silent = true })

  -- cmd+v | paste
  vim.keymap.set({ "n", "v", "x" }, "<D-v>", '"+p', { noremap = true, silent = true })
  vim.keymap.set("i", "<D-v>", '<C-o>"+p', { noremap = true, silent = true })

  -- cmd+w | Buffer Delete
  vim.keymap.set({ "n", "v", "x" }, "<D-w>", ":bd!<CR>",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-w>", "<C-o>:bd!<CR>",  { noremap = true, silent = true })

  -- cmd+z | Undo
  vim.keymap.set({ "n", "v", "x" }, "<D-z>", "u",  { noremap = true, silent = true })
  vim.keymap.set("i", "<D-z>", "<C-o>u", { noremap = true, silent = true })

  -- cmd-shift+z | Redo
  vim.keymap.set({ "n", "v", "x", "s" }, "<D-S-z>", "<cmd>redo<CR>", { noremap = true, silent = true })
  vim.keymap.set("i", "<D-S-z>", "<C-o><cmd>redo<CR>", { noremap = true, silent = true })

  -- Window Movement
  local win_move = {
    ["<D-h>"]  = "<C-w>h",
    ["<D-j>"]  = "<C-w>j",
    ["<D-k>"]    = "<C-w>k",
    ["<D-l>"] = "<C-w>l",
  }

  for k, v in pairs(win_move) do
    vim.keymap.set({ "n", "v", "x", "s" }, k, v, { noremap = true, silent = true })
    vim.keymap.set("i", k, "<C-o>" .. v, { noremap = true, silent = true })
  end

  vim.defer_fn(function()
    vim.cmd("NeovideFocus")
  end, 100)
end
