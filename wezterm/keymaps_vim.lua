local wezterm = require("wezterm")
local act = wezterm.action
local M = {}

local Sequence = act.Multiple
local Send = act.SendKey

function KeyBind(_keymod, _action)
	local result = {}
	for k, v in pairs(_keymod) do
		result[k] = v
	end
	for k, v in pairs(_action) do
		result[k] = v
	end
	return result
end

local asterix = { key = "*" }

local f1 = { key = "F1" }
local f2 = { key = "F2" }
local f3 = { key = "F3" }
local f4 = { key = "F4" }
local f5 = { key = "F5" }
local f6 = { key = "F6" }
local f7 = { key = "F7" }
local f8 = { key = "F8" }
local f9 = { key = "F9" }
local f10 = { key = "F10" }
local f11 = { key = "F11" }
local f12 = { key = "F12" }

local escape = { key = "Escape" }
local space = { key = "Space" }
local enter = { key = "Enter" }
local colon = { key = ":" }
local bang = { key = "!" }
local plus = { key = "+" }
local slash = { key = "/" }
local fslash = { key = "\\" }
local a = { key = "a" }
local b = { key = "b" }
local c = { key = "c" }
local d = { key = "d" }
local e = { key = "e" }
local f = { key = "f" }
local F = { key = "F" }
local g = { key = "g" }
local G = { key = "G" }
local h = { key = "h" }
local m = { key = "m" }
local q = { key = "q" }
local r = { key = "r" }
local s = { key = "s" }
local u = { key = "u" }
local V = { key = "V" }
local w = { key = "w" }
local y = { key = "y" }

local ctrlc = { key = "c", mods = "CTRL" }
local ctrlh = { key = "h", mods = "CTRL" }
local ctrli = { key = "i", mods = "CTRL" }
local ctrll = { key = "l", mods = "CTRL" }
local ctrlr = { key = "r", mods = "CTRL" }
local ctrlo = { key = "o", mods = "CTRL" }
local ctrlf1 = { key = "F1", mods = "CTRL" }
local ctrlf2 = { key = "F2", mods = "CTRL" }

local alte = { key = "e", mods = "OPT" }
local altf = { key = "f", mods = "OPT" }
local altp = { key = "p", mods = "OPT" }
local altu = { key = "u", mods = "OPT" }

local altshiftp = { key = "p", mods = "OPT|SHIFT" }
local altshiftm = { key = "m", mods = "OPT|SHIFT" }

local cmd9 = { key = "9", mods = "CMD" }
local cmda = { key = "a", mods = "CMD" }
local cmdc = { key = "c", mods = "CMD" }
local cmdd = { key = "d", mods = "CMD" }
local cmde = { key = "e", mods = "CMD" }
local cmdf = { key = "f", mods = "CMD" }
local cmdm = { key = "m", mods = "CMD" }
local cmdo = { key = "o", mods = "CMD" }
local cmdp = { key = "p", mods = "CMD" }
local cmdq = { key = "q", mods = "CMD" }
local cmds = { key = "s", mods = "CMD" }
local cmdr = { key = "r", mods = "CMD" }
local cmdw = { key = "w", mods = "CMD" }
local cmdz = { key = "z", mods = "CMD" }
local cmdslash = { key = "/", mods = "CMD" }

local cmdshiftd = { key = "d", mods = "CMD|SHIFT" }
local cmdshiftf = { key = "f", mods = "CMD|SHIFT" }
local cmdshifth = { key = "h", mods = "CMD|SHIFT" }
local cmdshiftg = { key = "g", mods = "CMD|SHIFT" }
local cmdshiftl = { key = "l", mods = "CMD|SHIFT" }
local cmdshifto = { key = "o", mods = "CMD|SHIFT" }
local cmdshiftp = { key = "p", mods = "CMD|SHIFT" }
local cmdshiftq = { key = "q", mods = "CMD|SHIFT" }
local cmdshiftr = { key = "r", mods = "CMD|SHIFT" }
local cmdshifts = { key = "s", mods = "CMD|SHIFT" }
local cmdshiftw = { key = "w", mods = "CMD|SHIFT" }
local cmdshiftz = { key = "z", mods = "CMD|SHIFT" }

M.keymaps_vim = {
	-- [cmd+/]: Comment Line gcc (tpope/vim-commentary: comment line)
	KeyBind(cmdslash, { action = Sequence({ Send(g), Send(c) }) }),
	-- [cmd+a]: :ggVG (Select all)
	KeyBind(cmda, { action = Sequence({ Send(escape), Send(g), Send(g), Send(V), Send(G), Send(enter) }) }),
	-- [cmd+d]: * (visualstar: select word under cursor)
	KeyBind(cmdd, { action = Sequence({ Send(escape), Send(asterix) }) }),
	-- [cmd+e]: netrw <F1> (Explorer)
	KeyBind(cmde, { action = Sequence({ Send(escape), Send(f11) }) }),
	-- [cmd+f]: Find in files: RgExactMatch <F5>
	KeyBind(cmdf, { action = Sequence({ Send(escape), Send(f5) }) }),
  -- [cmd+o]: Open Buffers <F9>
  KeyBind(cmdo, { action = Sequence({ Send(escape), Send(f9) }) }),
  -- [cmd+m]: Messages <F12>
  KeyBind(cmdm, { action = Sequence({ Send(escape), Send(f12) }) }),
	-- [cmd+p]: File Picker: All Files: <F12> 
	KeyBind(cmdp, { action = Sequence({ Send(escape), Send(f1) }) }),
	-- [cmd+q]: :q! (Force Quit)
	KeyBind(cmdq, { action = Sequence({ Send(escape), Send(colon), Send(q), Send(bang), Send(enter) }) }),
	-- [cmd+shift+w]: :qa! (Force Quit All!)
	KeyBind(cmdshiftw, { action = Sequence({ Send(escape), Send(f7) }) }),
	-- [cmd+r]: Session <space>ss
	KeyBind(cmdr, { action = Sequence({ Send(escape), Send(space), Send(s), Send(s) }) }),
	-- [cmd+s]: :w! (Save)
	KeyBind(cmds, { action = Sequence({ Send(escape), Send(colon), Send(w), Send(enter) }) }),
	-- [cmd+w]: :bd! (Buffer Delete)
	KeyBind(cmdw, { action = Sequence({ Send(escape), Send(f6) }) }),
	-- [cmd+z]: u (undo)
	KeyBind(cmdz, { action = Sequence({ Send(escape), Send(u) }) }),
  -- [alt+shift+m]: Messages: <\-m>
	KeyBind(altshiftm, { action = Sequence({ Send(escape), Send(fslash), Send(m) }) }),
	-- [cmd+shift+d]: Go to definition: cmd+shift+d -> gd
	KeyBind(cmdshiftd, { action = Sequence({ Send(escape), Send(g), Send(d) }) }),
	-- [cmd+shift+f]: Find in files: Rg <F4>
	KeyBind(cmdshiftf, { action = Sequence({ Send(escape), Send(f4) }) }),
	-- [cmd+shift+h]: <C-o> (Go back)
	KeyBind(cmdshifth, { action = Sequence({ Send(escape), Send(ctrlo) }) }),
	-- [cmd+shift+g]: gs (Go to symbol)
	KeyBind(cmdshiftg, { action = Sequence({ Send(escape), Send(g), Send(s) }) }),
	-- [cmd+shift+l]: <C-i> (Go forward)
	KeyBind(cmdshiftl, { action = Sequence({ Send(escape), Send(ctrli) }) }),
  -- [cmd+9]: Change theme: <F10> 
  KeyBind(cmd9, { action = Sequence({ Send(escape), Send(f10) }) }),
	-- [cmd+shift+p]: Commands: <F3>
	KeyBind(cmdshiftp, { action = Sequence({ Send(escape), Send(f3) }) }),
  -- [cmd+shift+s]: Save Session: <F11> 
  KeyBind(cmdshifts, { action = Sequence({ Send(escape), Send(f11) }) }),
	-- [cmd+shift+z]: <C-r> (redo)
	KeyBind(cmdshiftz, { action = Sequence({ Send(escape), Send(f8) }) }),

}

return M
