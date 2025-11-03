local M = {}

M.config = {
  is_dark = true
}

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

local function setup_themes(is_dark)
  if is_dark then
    -- Dark
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1a1a1a" })
    -- vim.g.lualine_theme = 'codedark'
    vim.g.lualine_theme = 'gruvbox'
    -- vim.g.lualine_theme = 'ayu_mirage'
    -- vim.g.lualine_theme = 'iceberg_dark'
    -- vim.g.lualine_theme = 'jellybeans'
    -- vim.g.lualine_theme = 'modus-vivendi'
    -- vim.g.lualine_theme = 'OceanicNext'
    -- vim.g.lualine_theme = 'onedark'
    -- vim.g.lualine_theme = 'palenight'
    -- vim.g.lualine_theme = 'powerline'
    vim.env.BAT_THEME = "Visual Studio Dark+"
    vim.o.background = "dark"
    -- vim.cmd.colorscheme("vscode")
    -- vim.cmd.colorscheme("carbonfox")
    -- vim.cmd.colorscheme("nightingale")
    -- vim.cmd.colorscheme("moonfly")
    -- vim.cmd.colorscheme("nightfly")
    -- vim.cmd.colorscheme("gruvbox")
    vim.cmd.colorscheme("retrobox")
  else
    -- Light
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#dadada" })
    vim.g.lualine_theme = 'onelight'
    vim.env.BAT_THEME = "OneHalfLight"
    vim.o.background = "light"
    vim.cmd.colorscheme("dayfox")
  end
end

M.setup = function(opts)
  opts = opts or {}
  M.config.is_dark = opts.is_dark or M.config.is_dark
  setup_theme_gruvbox()
  setup_themes(M.config.is_dark)

  -- Enforced Colors
  -- Setup visual selection color
  vim.api.nvim_set_hl(0, "Visual", { bg = "#0a541e", fg = "NONE" })
  -- Active mini tabline color
  -- vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#608b4e", fg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "MiniTablineCurrent", { bg = "#171515", fg = "#d79921", bold = true })
  -- vim.cmd([[highlight MiniTablineCurrent guibg=#142489 guifg=#ffffff]])
end

return M
