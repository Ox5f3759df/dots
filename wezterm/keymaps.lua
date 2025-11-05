local utils = require("utils")
local wezterm = require("wezterm")
local act = wezterm.action
local ascii = require("ascii")
local keymaps_vim = require("keymaps_vim").keymaps_vim

local key_tables = {
	search_mode = {
		{ key = "Enter",  mods = "NONE",  action = act.CopyMode("NextMatch") },
		{ key = "Enter",  mods = "SHIFT", action = act.CopyMode("PriorMatch") },
		{ key = "Escape", mods = "NONE",  action = act.CopyMode("Close") },
	},
	copy_mode = {
		{ key = ";",   mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "'",   mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine")},
		{ key = "Escape", mods = "NONE", action = act.Multiple({{ CopyMode = "Close" }})},
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" })},
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent")},
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent")},
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		-- { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } })},
		{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } })},
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom")},
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom")},
		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop")},
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom")},
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom")},
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle")},
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle")},
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz")},
		{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz")},
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } })},
		{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } })},
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" })},
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" })},
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent")},
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent")},
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT",  action = act.CopyMode("MoveBackwardWord") },
		{ key = "c", mods = "CTRL", action = act.Multiple({{ CopyMode = "Close" }})},
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 })},
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd")},
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } })},
		{ key = "f", mods = "ALT",  action = act.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop")},
		{ key = "g", mods = "CTRL", action = act.Multiple({{ CopyMode = "Close" }})},
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent")},
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd")},
		{ key = "q", mods = "NONE", action = act.Multiple({{ CopyMode = "Close" }})},
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } })},
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 })},
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" })},
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" })},
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "y", mods = "NONE", action = act.Multiple({{ CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" }})},
		{ key = "PageUp",   mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent")},
		{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine")},
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord")},
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight")},
		{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord")},
		{ key = "UpArrow",   mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
	},
}


local wez_kb = {
	-- Move focus to bottom of screen
	{ key = "b", mods = "SUPER",       action = act.ScrollToBottom },
	-- Tab Movement
	-- Focus Tab Left
	--{ key = "h", mods = "CTRL", action = wezterm.action.ActivateTabRelative(-1) },
	-- Focus Tab Right
	--{ key = "l", mods = "CTRL", action = wezterm.action.ActivateTabRelative(1) },
	-- Move tab left
	{ key = "h", mods = "CTRL|SHIFT",  action = act.MoveTabRelative(-1) },
	-- Move tab right
	{ key = "l", mods = "CTRL|SHIFT",  action = act.MoveTabRelative(1) },
	-- Paste
	{ key = "v", mods = "SUPER",       action = act.PasteFrom("Clipboard") },
	-- Clear Scrolback / Terminal
	{ key = "k", mods = "SUPER|SHIFT", action = act.ClearScrollback("ScrollbackAndViewport") },
	-- Quit Wezterm
	{ key = "q", mods = "OPT",         action = wezterm.action.QuitApplication },
	-- Pane: Split Horizontal
	{ key = "d", mods = "OPT",         action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Pane: Split Vertical
	{ key = "d", mods = "OPT|SHIFT",   action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Pane: Swap
	{ key = "s", mods = "OPT|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	-- Pane: Focus left
	{ key = "h", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	-- Pane: Focus right
	{ key = "l", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	-- Pane: Focus down
	{ key = "j", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	-- Pane:  Focus up
	{ key = "k", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "[", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	-- Pane: Focus right
	{ key = "]", mods = "SUPER",       action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	-- Pane: Adjust size left
	{ key = "-", mods = "OPT",         action = wezterm.action.AdjustPaneSize({ "Left", 10 }) },
	-- Pane: Adjust size right
	{ key = "=", mods = "OPT",         action = wezterm.action.AdjustPaneSize({ "Right", 10 }) },
	-- Pane: Adjust size down
	{ key = "F11", mods = "OPT",        action = wezterm.action.AdjustPaneSize({ "Down", 10 }) },
	-- Pane: Adjust size up
	{ key = "F12", mods = "OPT",        action = wezterm.action.AdjustPaneSize({ "Up", 10 }) },
	-- Tab: Close
	-- { key = "w", mods = "OPT",         action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
	{ key = "w", mods = "CTRL",         action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
	-- Tab: Spawn Tab
	{ key = "t", mods = "SUPER",       action = act.SpawnTab("CurrentPaneDomain") },
	-- Find: Search
	{ key = "f", mods = "SUPER|OPT",       action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
	-- Window: New
	{ key = "n", mods = "SUPER|SHIFT", action = wezterm.action.SpawnWindow },
	-- Window: Full Screeen
	{ key = "f", mods = "SUPER|CTRL",  action = wezterm.action.ToggleFullScreen },
	-- Window: Title
	{
		key = "t",
		mods = "OPT",
		action = act.PromptInputLine({
			description = ascii.tab_title,
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					local spaces = 1
					local new_line = string.rep(" ", spaces) .. " [" .. line .. "] " .. string.rep(" ", spaces)
					window:active_tab():set_title(new_line)
				end
			end),
		}),
	},
	-- Scroll: Pageup
	{ key = "PageUp",   action = act.ScrollByPage(-0.5) },
	-- Scroll: Pagedown
	{ key = "PageDown", action = act.ScrollByPage(0.5) },
	-- Scroll: Bottom
	{ key = ".",        mods = "SUPER|CTRL",            action = wezterm.action.ScrollToBottom },
	{ key = ",",        mods = "SUPER|CTRL",            action = wezterm.action.ScrollToBottom },
	-- Scroll: Bottom
	{ key = ".",        mods = "CTRL",                  action = wezterm.action.ScrollToBottom },
	-- Scroll: Up
	{ key = ".",        mods = "CTRL",                  action = wezterm.action.ScrollByLine(-1) },
	-- Copy Mode
	{ key = "c", mods = "OPT|SHIFT",         action = act.ActivateCopyMode },
	{ key = "c", mods = "SUPER|SHIFT",         action = act.ActivateCopyMode },
}

return {
	keys = utils.TableConcat(wez_kb, keymaps_vim),
	key_tables = key_tables,
}
