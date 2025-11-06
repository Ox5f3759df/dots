local is_dark = true
-- local is_dark = false

local M = {}

M.config = {}

local function setup_theme_gruvbox()
	require("gruvbox").setup({
		terminal_colors = true, -- add neovim terminal colors
		undercurl = true,
		underline = true,
		bold = true,
		italic = {
			strings = false,
			emphasis = false,
			comments = false,
			operators = false,
			folds = false,
		},
		strikethrough = true,
		invert_selection = false,
		invert_signs = false,
		invert_tabline = false,
		inverse = true, -- invert background for search, diffs, statuslines and errors
		contrast = "", -- can be "hard", "soft" or empty string
		palette_overrides = {},
		overrides = {},
		dim_inactive = false,
		transparent_mode = false,
	})
end

local function setup_lualine_theme()
	if is_dark then
		-- Dark
		-- vim.g.lualine_theme = 'codedark'
		-- vim.g.lualine_theme = 'ayu_mirage'
		-- vim.g.lualine_theme = 'iceberg_dark'
		-- vim.g.lualine_theme = 'jellybeans'
		-- vim.g.lualine_theme = 'modus-vivendi'
		-- vim.g.lualine_theme = 'OceanicNext'
		-- vim.g.lualine_theme = 'onedark'
		-- vim.g.lualine_theme = 'palenight'
		-- vim.g.lualine_theme = 'powerline'
		vim.g.lualine_theme = "gruvbox"
	else
		vim.g.lualine_theme = "onelight"
	end
end

local function setup_themes()
	if is_dark then
		-- Dark
		vim.cmd.colorscheme("vscode")
	else
		-- Light
		vim.cmd.colorscheme("dayfox")
	end
end

local function setup_color_overrides()
  -- Overrides
	if is_dark then
		vim.o.background = "dark"
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1a1a" })
		vim.api.nvim_set_hl(0, "Visual", { bg = "#0a541e", fg = "NONE" })
		-- vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#171515", fg = "#d79921", bold = true })
		vim.env.BAT_THEME = "Visual Studio Dark+"
    -- Set Inactive Split Color
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#13131a" }) -- darker inactive background
	else
		vim.o.background = "light"
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#dadada" })
		-- vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#171515", fg = "#d79921", bold = true })
		vim.env.BAT_THEME = "OneHalfLight"
    -- Set Inactive Split Color
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#d3d3d3" }) -- darker inactive background
	end
end

local function setup_diffview_color_overrides()
  if is_dark then
    vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle", { fg = "#c678dd", bold = true })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelFileName", { fg = "#61afef" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelPath", { fg = "#5c6370" })
    vim.api.nvim_set_hl(0, "DiffviewFolderSign", { fg = "#e06c75" })
  else
    -- Light mode equivalents
    vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle",   { fg = "#a626a4", bold = true })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter", { fg = "#22863a" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelFileName",{ fg = "#005cc5" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelPath",    { fg = "#6a737d" })
    vim.api.nvim_set_hl(0, "DiffviewFolderSign",       { fg = "#d73a49" })
  end
end

local function setup_mini_color_overrides()
	if is_dark then
    -- mini.tabline
		vim.api.nvim_set_hl(0, "MiniTablineCurrent", {bg = "#171515"})
    -- mini.jump.jump2d
    vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = '#c678dd', sp = '#c678dd', underdouble = true })
    vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = '#e06c75', sp = '#e06c75', underdouble = true })
  else
    -- mini.tabline
		vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#3d3d3d", fg = "#ffffff" })
    -- mini.jump.jump2d
    vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = '#a626a4', sp = '#a626a4', underdouble = true })
    vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', { fg = '#d73a49', sp = '#d73a49', underdouble = true })
  end
end


M.setup = function(opts)
	opts = opts or {}
	setup_lualine_theme()
	setup_theme_gruvbox()
	setup_themes()
  setup_color_overrides()
  setup_diffview_color_overrides()
  setup_mini_color_overrides()
end

return M
