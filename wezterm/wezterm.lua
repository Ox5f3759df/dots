local wezterm = require("wezterm")
local keymaps = require("keymaps")
local base_themes = require("themes.base_themes")
local is_dark = true;
-- local is_dark = false;

local theme = is_dark and base_themes.dark or base_themes.light
local font_size = 16
local font_weight = 500
local font_family = "JetBrainsMono Nerd Font Mono"
local tab_font_family = "Iosevka Aile"
local font_line_height = 1.15
local tab_max_width = 200
local tab_fancy_font_size = 18
local use_fancy_tabs = false
local tabs_at_bottom = false
local config = wezterm.config_builder()

config.use_fancy_tab_bar = use_fancy_tabs
config.tab_max_width = tab_max_width
config.color_scheme = theme
config.keys = keymaps.keys
config.key_tables = keymaps.key_tables
config.font = wezterm.font(font_family)
config.font_size = font_size
config.line_height = font_line_height
config.enable_scroll_bar = true
config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
config.adjust_window_size_when_changing_font_size = false
config.scroll_to_bottom_on_input = true
config.show_tabs_in_tab_bar = true
config.tab_bar_at_bottom = tabs_at_bottom
config.show_new_tab_button_in_tab_bar = false
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}
config.window_frame = {
  font_size = tab_fancy_font_size,
  font = wezterm.font(tab_font_family, {weight = font_weight})
}
config.window_padding = {
  left = "0.5cell",
  right = "0.5cell",
  top = "0cell",
  bottom = "0cell"
}

config.colors = {
  tab_bar = {
    active_tab = {
      -- bg_color = '#3c3153',
      -- fg_color = '#ffffff'
      bg_color = '#171515',
      fg_color = '#d79921'
    },
    inactive_tab = {
      -- bg_color = '#0a0021',
      -- bg_color = '#171515',
      bg_color = '#3c3836',
      fg_color = '#808080',
    },
  }
}

wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime '%Y/%m/%d | %H:%M:%S'

  -- Make it italic and underlined
  window:set_right_status(wezterm.format {
    -- { Attribute = { Underline = 'Single' } },
    -- { Attribute = { Italic = true } },
    { Text = date .. '  ' },
  })
end)

local function last_n_components(path, n)
    local components = {}
    for part in path:gmatch("[^/]+") do
        table.insert(components, part)
    end
    local start_idx = math.max(#components - n + 1, 1)
    return table.concat(components, "/", start_idx)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local cwd_uri = pane.current_working_dir
  local cwd = ""
  if cwd_uri then
    cwd = cwd_uri.file_path or ""
    cwd = cwd:gsub(wezterm.home_dir, "~") -- shorten home dir
  end
  cwd = last_n_components(cwd, 3)
  local proc_name = tab.active_pane.foreground_process_name or ""
  -- Strip everything before the last slash
  proc_name = proc_name:match("([^/]+)$") or proc_name
  return {
    { Text = string.format(" %d: %s  ", tab.tab_index + 1, cwd or "") },
    { Foreground = { Color = "Gray" } },
    -- { Text = string.format("%s ", proc_name ) },
  }
end)

return config
