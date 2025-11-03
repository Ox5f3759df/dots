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
vim.o.termguicolors = true
vim.o.sessionoptions = "curdir,folds,winpos,winsize,localoptions"

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
}
------------------------------------------------------------------------------------------
-- Plugins Groups
------------------------------------------------------------------------------------------
require("commands").setup({
  side = "right",
})

require("wiki").setup({
  keys = {
    open_daily_note_cmd = "<space>d"
  }
})
require("lsp").setup({})
require("git").setup({})
require("ui").setup({})
require("theme").setup({
  is_dark = is_dark
})
------------------------------------------------------------------------------------------
-- Autocommands
------------------------------------------------------------------------------------------
-- FT autocommands
require("ft.c").autocommands()
require("ft.cpp").autocommands()
require("ft.go").autocommands()
require("ft.js").autocommands()
require("ft.lua").autocommands()
require("ft.python").autocommands()
require("ft.rust").autocommands()
require("ft.zig").autocommands()

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
local opts = { noremap = true, silent = true }
map("n", "<space>e", ":lua require('oil').open_float()<CR>", opts)  -- <S>e : Oil
map("n", "<space>m", ":Mason<CR>", opts)                            -- <S>m : Mason
map("n", "<space>n", ":noh<CR>", opts)                              -- <S>n : Disable Selection
map("n", "<space>l", ":LspInfo<CR>", opts)                          -- <S>l : LspInfo
map("n", "<space>r", ":FzfLua registers<CR>", opts)                 -- <S>r : Select register to paste
map("n", "<space>sd", ":AutoSession deletePicker<CR>", opts)        -- <S>sd : Session Delete picker
map("n", "<space>ss", ":AutoSession search<CR>", opts)              -- <S>ss : Session Search
map("n", "<space>t", ":TSInstallInfo<CR>", opts)                    -- <S>t : TreeSitter Install Info
map("n", "<space>u", ":lua vim.pack.update()<CR>", opts)            -- <S>u : Update vim.pack
map("n", "<space><BS>", function()DeleteOtherBuffers()end, opts)    -- <S><BS> : Close other bufffers

map("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>", opts)        -- \f  : Format file
map("n", "<leader>n", ":noh<CR>", opts)                             -- \n  : Disable Selection
map("n", "<leader>o", "gx", opts)                                   -- \o  : Open links

-- map("n", "<leader>r", function()
--   vim.notify("Reloading neovim")
--   dofile(vim.env.MYVIMRC)
--   end, opts)                                                        -- \r  : Reload Neovim

map("n", "<F1>", ":FzfLua files<CR>", opts)                         -- F1  : Fuzzy find files
map("n", "<F2>", ":FzfLua oldfiles<CR>", opts)                      -- F2  : Fuzzy recent files
map("n", "<F3>", ":FzfLua commands<CR>", opts)                      -- F3  : Fuzzy show commands
map("n", "<F4>", ":FzfLua grep<CR>", opts)                          -- F4  : Fuzzy grep
map("n", "<F5>", ":FzfLua live_grep<CR>", opts)                     -- F5  : Fuzzy live grep
map("n", "<F6>", ":bd!<CR>", opts)                                  -- F6  : Close window
map("n", "<F7>", ":qa!<CR>", opts)                                  -- F7  : Close window all force!
map("n", "<F8>", ":redo<CR>", opts)                                 -- F8  : Redo
map("n", "<F9>", ":FzfLua oldfiles<CR>", opts)                      -- F9  : Fuzzy recent files
map("n", "<F10>", ":FzfLua colorschemes<CR>", opts)                 -- F10 : Fuzzy colorschemes
map("n", "<F11>", ":lua require('oil').open_float()<CR>", opts)     -- F11 : File Explorer
map("n", "<F12>", ":messages<CR>", opts)                            -- F12 : Messages

map("n", "e", "<C-w>", opts)                                        -- e  : Remap <C-w> wincmd
map("n", "eL", ":vsplit | wincmd l | b# | close#<CR>", opts)        -- eL : Editor split right
map("n", "e=", "10<C-w>>", opts)                                    -- e= : Editor reisze >
map("n", "e-", "10<C-w><", opts)                                    -- e- : Editor resize <
map("n", "e+", "10<C-w>=", opts)                                    -- e+ : Editor resize up
map("n", "e_", "10<C-w>-", opts)                                    -- e_ : Editor resize down
map("n", "e[", ":bp<CR>", opts)                                      -- H : Next tab
map("n", "e]", ":bn<CR>", opts)                                      -- L : Prev tab
map("n", "e<BS>", function()DeleteOtherBuffers()end, opts)          -- e<BS> : Close other bufffers


map("n", "gb", ":Gitsigns blame<CR>", opts)                         -- gb : Gitsigns blame
map("n", "gh", ":Gitsigns setloclist target=all<CR>", opts)         -- gh : Gitsigns show all hunks
map("n", "gg", ":Gitsigns reset_hunk<CR>", opts)                    -- gl : Gitsigns reset hunk
map("n", "gj", ":Gitsigns nav_hunk next<CR>", opts)                 -- gj : Gitsigns next hunk
map("n", "gk", ":Gitsigns nav_hunk prev<CR>", opts)                 -- gk : Gitsigns prev hunk
map("n", "gl", ":Gitsigns blame_line<CR>", opts)                    -- gl : Gitsigns blame line
map("n", "g<BS>", ":Gitsigns reset_hunk<CR>", opts) 

map("n", "H", ":bp<CR>", opts)                                      -- H : Next tab
map("n", "L", ":bn<CR>", opts)                                      -- L : Prev tab



map("n", "m'", "'", opts)                                           -- m'     : Marks Go to <target>
map("n", "m<BS>", ":delmarks!<CR>", opts)                           -- dm<BR> : Marks Delete all marks
map("n", "m\\", ":MarksListAll<CR>", opts)                          -- m\     : Marks List all
-- map("x", "y", '"+yy', opts)                                      -- Y      : Yank to Global clipboard
map("x", "Y", '"+yy', opts)                                         -- Y      : Yank to Global clipboard

map("n", "tJ",
  ":lua vim.cmd('botright split') vim.cmd('lcd %:p:h') vim.cmd('terminal') vim.cmd('resize -10') vim.cmd('startinsert')<CR>",
  opts)
map("n", "th", ":vsplit | terminal<CR>", opts)                      -- th : Split terminal left
map("n", "tl", ":vert rightbelow split | terminal<CR>", opts)       -- tl : Split terminal right
map("n", "ts", TrimTrailingWhitespaces, opts)                       -- ts : Trim Trailing White space

map("n", "tj", vim.diagnostic.goto_next, opts)                      -- Jump to next diagnostic"
map("n", "tk", vim.diagnostic.goto_prev, opts)                      -- Jump to prev diagnostic"

map("t", "<Esc>", '<C-\\><C-n>', opts)                              -- <ESC> : Go back to normal when in termimal mode
map("t", '<F1>', 'exit<CR><CR>', opts)                              -- <F1>  : Exit terminal

map("n", ";", "<C-d>", opts)                                        -- ; : Pagedown
map("n", "'", "<C-u>", opts)                                        -- ' : Pageup
map("n", ".", "*", opts)                                            -- . : Select word and next occurence
map("n", ",", "#", opts)                                            -- , : Select word and prev occurence
