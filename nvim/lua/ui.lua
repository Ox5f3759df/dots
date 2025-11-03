local M = {}

local config = {}

local function setup_plugin_miniharp()
  -- Miniharp: like harpoon2
  local miniharp = require('miniharp')
  miniharp.setup({
    autoload = true, -- load marks for this cwd on startup (default: true)
    autosave = true, -- save marks for this cwd on exit (default: true)
    show_on_autoload = true, -- show popup list after a successful autoload (default: false)
  })
  vim.keymap.set('n', '<C-s>', miniharp.toggle_file,                                                            { desc = 'miniharp: toggle file mark' })
  vim.keymap.set('n', '<leader>s', miniharp.toggle_file,                                                        { desc = 'miniharp: toggle file mark' })
  vim.keymap.set('n', "<C-'>", miniharp.next,                                                                   { desc = 'miniharp: next file mark' })
  vim.keymap.set('n', '<C-;>', miniharp.prev,                                                                   { desc = 'miniharp: prev file mark' })
  -- vim.keymap.set('n', '<C-g>', miniharp.show_list,                                                              { desc = 'miniharp: list marks' })
  -- vim.keymap.set('n', '<leader>g', miniharp.show_list,                                                          { desc = 'miniharp: list marks' })
  -- vim.keymap.set('n', '<leader>X', function() miniharp.clear(); vim.notify('miniharp: cleared all marks') end,  { desc = 'miniharp: clear marks' })
  vim.keymap.set('n', '<C-x>', function() miniharp.clear(); vim.notify('miniharp: cleared all marks') end,      { desc = 'miniharp: clear marks' })
end

local function setup_plugin_autosession()
  -- Autosession
  require("auto-session").setup({})
end


local function setup_plugin_mini_tabline()
  require('mini.tabline').setup()
end

local function setup_plugin_lualine()


  local function datetime()
    return os.date("%Y/%m/%d %H:%M")
  end

  -- Lualine
  require('lualine').setup({
    options = {
      theme = vim.g.lualine_theme,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      -- globalstatus = true,

    },
    winbar = {
      lualine_c = { { "navic", color_correction = "static" }  },
      -- lualine_x = { "venv-selector" },
      lualine_x = { "venv-selector", { 'filename', path = 1, }, 'progress' }, -- 1: relative 2: fullpath 3. fullpathv2
      -- lualine_z = { }
      -- lualine_z = { datetime },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      -- lualine_c = { { 'filename', path = 1, }, 'progress' }, -- 1: relative 2: fullpath 3. fullpathv2
      lualine_z = { 'diff', 'diagnostics', 'filetype'  },
    },
  })
end

local function setup_plugin_marks()
  require'marks'.setup({
    -- whether to map keybinds or not. default true
    default_mappings = true
  })
end

local function setup_plugin_fzf_lua()
  local fzflua = require("fzf-lua")
  fzflua.setup({
    files = {
      cmd = "fd --type f --follow --hidden --exclude .git",
      file_icons = false
    },
    winopts = {
      height = 1.0,
      preview = {
        layout = "vertical",
        vertical = "up:50%",
      },
    },
    fzf_opts = {
      ["--inline-info"] = "",
      ["--layout"] = "reverse",
      ["--ansi"] = "",
      ["--color"] = "gutter:-1",
      ["--bind"] = "ctrl-j:down,ctrl-k:up,ctrl-h:page-up,ctrl-l:page-down",
    },
  })

  -- Rg fuzzy without searching filename
  vim.api.nvim_create_user_command("Rg", function(opts)
    fzflua.grep_project({
      cmd = "rg -L --hidden --column --line-number --no-heading --color=always --smart-case " .. opts.args,
      fzf_opts = { ["--delimiter"] = ":", ["--nth"] = "4.." },
    })
  end, { nargs = "*" })
end

local function setup_plugin_dressing()
  -- Dressing
  require("dressing").setup({
    input = {
      -- Set to false to disable the vim.ui.input implementation
      enabled = true,
      -- Default prompt string
      default_prompt = "Input",
      -- Trim trailing `:` from prompt
      trim_prompt = true,
      -- Can be 'left', 'right', or 'center'
      title_pos = "left",
      -- The initial mode when the window opens (insert|normal|visual|select).
      start_mode = "insert",
      -- These are passed to nvim_open_win
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      -- relative = "cursor",
      relative = "win",
      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      prefer_width = 40,
      width = nil,
      -- min_width and max_width can be a list of mixed types.
      -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
      max_width = { 140, 0.9 },
      min_width = { 20, 0.2 },
      buf_options = {},
      win_options = {
        -- Disable line wrapping
        wrap = false,
        -- Indicator for when text exceeds window
        list = true,
        listchars = "precedes:…,extends:…",
        -- Increase this for more context when text scrolls off the window
        sidescrolloff = 0,
      },
      -- Set to `false` to disable
      mappings = {
        n = {
          ["<Esc>"] = "Close",
          ["<CR>"] = "Confirm",
        },
        i = {
          ["<C-c>"] = "Close",
          ["<CR>"] = "Confirm",
          ["<Up>"] = "HistoryPrev",
          ["<Down>"] = "HistoryNext",
        },
      }
    }
  })
end

local function setup_plugin_oil()
  local oil = require("oil")
  oil.setup({
    -- Use this if you're not using oil open_float
    -- win_options = {
    --   winbar = "%!v:lua.get_oil_winbar()",
    -- },
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 2,
      -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      max_width = 0.8,
      max_height = 0.5,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
      get_win_title = nil,
      preview_split = "auto",
      override = function(conf)
        return conf
      end,
    },
    default_file_explorer = true,
    keymaps = {
      -- Close
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<M-Esc>"] = { "actions.close", mode = "n" },
      ["q"] = { "actions.close", mode = "n" },
      -- Select
      ["<CR>"] = { "actions.select", mode = "n" },
      -- Parent
      ["-"] = { "actions.parent", mode = "n" },
      ["h"] = { "actions.parent", mode = "n" },
      ["<Tab>"] = { "actions.parent", mode = "n" },
      -- Change to workspace directory
      ["_"] = { "actions.open_cwd", mode = "n" },
      -- Change directory
      ["`"] = { "actions.cd", mode = "n" },
      -- Toggle hidden
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      -- Help
      ["g?"] = { "actions.show_help", mode = "n" },
      ["?"] = { "actions.show_help", mode = "n" },
      -- Custom
      ["="] = {
        desc = "Copy relative path to clipboard",
        callback = function()
          local entry = oil.get_cursor_entry()
          if not entry then
            vim.notify("No entry selected", vim.log.levels.WARN)
            return
          end
          local full_path = oil.get_current_dir() .. entry.name
          local rel_path = vim.fn.fnamemodify(full_path, ":.")
          vim.fn.setreg("+", rel_path)
          vim.notify("Copied: " .. rel_path)
        end,
      }
    }
  })
end

function M.setup(opts)
  opts = opts or {}
  setup_plugin_oil()
  setup_plugin_dressing()
  setup_plugin_autosession()
  setup_plugin_fzf_lua()
  setup_plugin_lualine()
  setup_plugin_marks()
  setup_plugin_miniharp()
  setup_plugin_mini_tabline()

end

return M
