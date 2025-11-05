local is_dark = true;
-- local is_dark = false;
------------------------------------------------------------------------------------------
-- Neovim Configuration
------------------------------------------------------------------------------------------
-- Globals & Options
------------------------------------------------------------------------------------------
-- vim.g.mapleader = "\\"
vim.opt.cursorline = true
-- vim.opt.confirm = true
-- autoread and updatetime used with autocommands to reload file if changed externally
vim.opt.autoread = true
vim.opt.updatetime = 1000
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.background = "dark"
vim.o.number = true
vim.o.mouse = "a"
vim.o.helpheight = 99999
vim.o.sessionoptions = "curdir,folds,winpos,winsize,localoptions"
vim.opt.termguicolors = true
vim.opt.lazyredraw = false

-- Required for vim.obsidian
vim.opt.conceallevel = 2
vim.cmd.syntax("on")

-- Neovide
if vim.g.neovide then pcall(require, "neovide") end
------------------------------------------------------------------------------------------
-- Install Plugins
------------------------------------------------------------------------------------------
vim.pack.add {
  -- LSP
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/folke/trouble.nvim' },
  { src = 'https://github.com/lewis6991/hover.nvim' },
  { src = 'https://github.com/Saghen/blink.cmp' },
  { src = 'https://github.com/linux-cultist/venv-selector.nvim' }, -- python venv
  { src = 'https://github.com/SmiteshP/nvim-navic' }, -- breadcrumbs
  -- Themes
  { src = 'https://github.com/EdenEast/nightfox.nvim' },
  { src = 'https://github.com/Mofiqul/vscode.nvim' },
  { src = 'https://github.com/xeind/nightingale.nvim' },
  { src = 'https://github.com/bluz71/vim-moonfly-colors' },
  { src = 'https://github.com/bluz71/vim-nightfly-colors' },
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
  -- Other
  { src = 'https://github.com/nvim-mini/mini.clue' },
  { src = 'https://github.com/akinsho/toggleterm.nvim' },
  { src = 'https://github.com/vieitesss/miniharp.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/rmagatti/auto-session' },
  { src = 'https://github.com/chentoast/marks.nvim' },
  { src = 'https://github.com/stevearc/dressing.nvim' },
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  -- Tabline
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  -- Vim Plugins
  { src = 'https://github.com/mg979/vim-visual-multi' },
  { src = 'https://github.com/tpope/vim-surround' },
  { src = 'https://github.com/tpope/vim-repeat' },
  { src = 'https://github.com/tpope/vim-commentary' },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/godlygeek/tabular' },
  { src = 'https://github.com/nvim-mini/mini.tabline' },
  -- Git
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/sindrets/diffview.nvim' },
  { src = 'https://github.com/NeogitOrg/neogit' },
  -- AI
  { src = 'https://github.com/github/copilot.vim' },
  { src = 'https://github.com/CopilotC-Nvim/CopilotChat.nvim' },
}
------------------------------------------------------------------------------------------
-- Plugins Groups
------------------------------------------------------------------------------------------
require("ai").setup({})
require("commands").setup({
  side = "right",
})
require("git").setup({})
require("lsp").setup({})
require("theme").setup({
  is_dark = is_dark
})
require("ui").setup({})
require("wiki").setup({
  keys = {
    open_daily_note_cmd = "<space>d"
  }
})
------------------------------------------------------------------------------------------
-- Autocommands
------------------------------------------------------------------------------------------
-- Find and enable all FT autocommands
local ft_dir = vim.fn.stdpath("config") .. "/lua/ft"
local exclude_mod_name = "ft/_template"
local files = vim.fn.glob(ft_dir .. "/*.lua", false, true)
for _, file in ipairs(files) do
  local mod_name = file:match("lua/(.*)%.lua$")
  if mod_name and mod_name ~= exclude_mod_name then
    require(mod_name).autocommands()
  end
end

-- Update wezterm title on enter
vim.api.nvim_create_autocmd({"BufEnter"}, {
    callback = function(event)
        local title = "vim"
        if event.file ~= "" then
            title = string.format("vim: %s", vim.fs.basename(event.file))
        end

        vim.fn.system({"wezterm", "cli", "set-tab-title", title})
    end,
})
vim.api.nvim_create_autocmd({"VimLeave"}, {
    callback = function()
        -- Setting title to empty string causes wezterm to revert to its
        -- default behavior of setting the tab title automatically
        vim.fn.system({"wezterm", "cli", "set-tab-title", ""})
    end,
})
vim.api.nvim_create_augroup("AutoReloadOnCursor", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
  group = "AutoReloadOnCursor",
  pattern = "*",
  command = "checktime"
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
------------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------------
-- Deletes all trailing whitespaces in a file if it's not binary nor a diff.
function TrimTrailingWhitespaces()
    if not vim.o.binary and vim.o.filetype ~= 'diff' then
        local current_view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(current_view)
    end
end
function DeleteOtherBuffers()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end
vim.api.nvim_create_user_command("DeleteOtherBuffers", DeleteOtherBuffers, {})
------------------------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------------------------
local map = vim.keymap.set
local opts = function(x) return { noremap = true, silent = true, desc = x or "" } end

map("n", "<space>e", ":lua require('oil').open_float()<CR>",                                                            opts('Oil'))
map("n", "<space>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { bufnr = 0 }) end, opts("Toggle LSP Inlay Hints"))
map("n", "<space>m", ":Mason<CR>",                                                                                      opts('Mason'))
map("n", "<space>n", ":noh<CR>",                                                                                        opts(':noh'))
map("n", "<space>l", ":LspInfo<CR>",                                                                                    opts('LspInfo'))
map("n", "<space>r", ":FzfLua registers<CR>",                                                                           opts('Registers'))
map("n", "<space>sd", ":AutoSession deletePicker<CR>",                                                                  opts('Autosession: delete'))
map("n", "<space>ss", ":AutoSession search<CR>",                                                                        opts('Autosession: search'))
map("n", "<space>t", ":TSInstallInfo<CR>",                                                                              opts('TSInstallInfo'))
map("n", "<space>u", ":lua vim.pack.update()<CR>",                                                                      opts('Vim Pack: Update'))
map("n", "<space><BS>", function() DeleteOtherBuffers() end,                                                            opts('Editor: Close all buffers except current'))
map("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>",                                                                  opts('LSP: Format File'))
map("n", "<leader>n", ":noh<CR>",                                                                                       opts(':noh'))
map("n", "<leader>o", "gx",                                                                                             opts('Open Links'))
map("n", "<F1>", ":FzfLua files<CR>",                                                                                   opts('FzfLua: liles'))
-- Note: Map F2 to snippets
map("n", "<F3>", ":FzfLua commands<CR>",                                                                                opts('FzfLua: commands'))
map("n", "<F4>", ":FzfLua grep<CR>",                                                                                    opts('FzfLua: grep'))
map("n", "<F5>", ":FzfLua live_grep<CR>",                                                                               opts('FzfLua: live_grep'))
map("n", "<F6>", ":bd!<CR>",                                                                                            opts('Windows: close all'))
map("n", "<F7>", ":qa!<CR>",                                                                                            opts('Windows: Force Close'))
map("n", "<F8>", ":redo<CR>",                                                                                           opts('Redo'))
map("n", "<F9>", ":FzfLua oldfiles<CR>",                                                                                opts('FzfLua: oldfiles'))
map("n", "<F10>", ":FzfLua colorschemes<CR>",                                                                           opts('FzfLua: colorschemes'))
map("n", "<F11>", ":lua require('oil').open_float()<CR>",                                                               opts('Oil'))
map("n", "<F12>", ":messages<CR>",                                                                                      opts('Messages'))
map("n", "e=", "10<C-w>>",                                                                                              opts('Editor: Resize >'))
map("n", "e-", "10<C-w><",                                                                                              opts('Editor: Resize <'))
map("n", "e", "<C-w>",                                                                                                  opts('Wincmd'))
map("n", "eL", ":vsplit | wincmd l | b# | close#<CR>",                                                                  opts('Editor: Split right'))
map("n", "e+", "10<C-w>=",                                                                                              opts('Editor: Resize up'))
map("n", "e_", "10<C-w>-",                                                                                              opts('Editor: Resize down'))
map("n", "e[", ":bp<CR>",                                                                                               opts('Editor: Next Tab'))
map("n", "e]", ":bn<CR>",                                                                                               opts('Editor: Prev Tab'))
map("n", "e<BS>", function() DeleteOtherBuffers() end,                                                                  opts('Editor: Close all buffers except current'))
map("n", "H", ":bp<CR>",                                                                                                opts('Editor: Next Tab'))
map("n", "L", ":bn<CR>",                                                                                                opts('Editor: Prev Tab'))
map("n", "m'", "'",                                                                                                     opts('Marks: Goto<target>'))
map("n", "m<BS>", ":delmarks!<CR>",                                                                                     opts('Marks: Delete all marks'))
map("n", "m\\", ":MarksListAll<CR>",                                                                                    opts('Marks: List all'))
map("x", "Y", '"+yy',                                                                                                   opts('Copy: Yank to Global Clipboard'))
map("n", "ts", TrimTrailingWhitespaces,                                                                                 opts('Trim: Trailing Whitespaces'))
map("n", ";", "<C-d>",                                                                                                  opts('Pagedown'))
map("n", "'", "<C-u>",                                                                                                  opts('Pageup'))
map("n", ".", "*",                                                                                                      opts('Select word and next occurence'))
map("n", ",", "#",                                                                                                      opts('Select word and prev occurence'))
map("n", "?", ":FzfLua grep_cword<CR>",                                                                                 opts('Search word under cursor in project'))

-- Clues
local triggers = {}
local add_triggers = function(modes, key)
  for _, mode in ipairs(modes) do
    table.insert(triggers, { mode = mode, keys = key })
  end
end

add_triggers({ 'n', 'x' }, '<leader>')
add_triggers({ 'n', 'v', 'x' }, '<space>')
add_triggers({ 'n', 'v', 'x' }, '<C-a>')
add_triggers({ 'n', 'v', 'x' }, 'e')
add_triggers({ 'n', 'v', 'x' }, 'g')
add_triggers({ 'n', 'v', 'x' }, 'm')
require('mini.clue').setup({ triggers = triggers })

