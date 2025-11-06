local M = {}

M.install = function()
	vim.pack.add({
		-- AI
		{ src = "https://github.com/github/copilot.vim" },
		{ src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },

		-- Git
		{ src = "https://github.com/sindrets/diffview.nvim" },

		-- LSP
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/mason-org/mason.nvim" },
		{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
		{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
		{ src = "https://github.com/folke/trouble.nvim" },
		{ src = "https://github.com/lewis6991/hover.nvim" },
		{ src = "https://github.com/Saghen/blink.cmp" },
		{ src = "https://github.com/linux-cultist/venv-selector.nvim" }, -- python venv

		-- Mini
    -- [keymaps]
		{ src = "https://github.com/nvim-mini/mini.clue" },
    -- [editor]
    { src = "https://github.com/nvim-mini/mini.jump" },
    { src = "https://github.com/nvim-mini/mini.jump2d" },
    { src = "https://github.com/nvim-mini/mini.splitjoin" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    -- [git]
    { src = "https://github.com/nvim-mini/mini.pairs" },
    -- [ui]
    { src = "https://github.com/nvim-mini/mini.indentscope" },
    { src = "https://github.com/nvim-mini/mini.notify" },
		{ src = "https://github.com/nvim-mini/mini.tabline" },

		---- Themes
		{ src = "https://github.com/EdenEast/nightfox.nvim" },
		{ src = "https://github.com/Mofiqul/vscode.nvim" },
		{ src = "https://github.com/xeind/nightingale.nvim" },
		{ src = "https://github.com/bluz71/vim-moonfly-colors" },
		{ src = "https://github.com/bluz71/vim-nightfly-colors" },
		{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
		{ src = "https://github.com/SmiteshP/nvim-navic" }, -- breadcrumbs

		-- UI
		{ src = "https://github.com/vieitesss/miniharp.nvim" },
		{ src = "https://github.com/stevearc/dressing.nvim" },
		{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
		{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },

    -- Utilities
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
		{ src = "https://github.com/ibhagwan/fzf-lua" },
		{ src = "https://github.com/stevearc/oil.nvim" },
		{ src = "https://github.com/rmagatti/auto-session" },
		{ src = "https://github.com/akinsho/toggleterm.nvim" },

		-- Vim Plugins
		{ src = "https://github.com/mg979/vim-visual-multi" },
		{ src = "https://github.com/tpope/vim-commentary" },

    -- Unused
		-- { src = "https://github.com/tpope/vim-surround" },
		-- { src = "https://github.com/tpope/vim-repeat" },
		-- { src = "https://github.com/tpope/vim-fugitive" },
		-- { src = "https://github.com/godlygeek/tabular" },
		-- { src = "https://github.com/lewis6991/gitsigns.nvim" },
		-- { src = "https://github.com/NeogitOrg/neogit" },
    -- { src = "https://github.com/nvim-mini/mini.diff" },
	})
end

return M
