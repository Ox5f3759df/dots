vim.g.mapleader = "\\"
vim.opt.cursorline = true
-- vim.opt.confirm = true
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
-- diff opts
vim.o.diffopt = 'internal,filler,closeoff,linematch:40'

-- Required for vim.obsidian
vim.opt.conceallevel = 2
vim.cmd.syntax("on")

-- Neovide
if vim.g.neovide then
	pcall(require, "neovide")
end

require("plugins").install()
require("autocommands").setup({})
require("ai").setup({})
require("commands").setup({ side = "right" })
require("editor").setup({})
require("git").setup({})
require("lsp").setup({})
require("keymaps").setup({})
require("theme").setup({})
require("ui").setup({})
require("wiki").setup({})
