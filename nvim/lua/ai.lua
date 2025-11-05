local M = {}

M.config = {
	keys = {
		copilot_accept = "<C-Enter>",
		copilot_status = "<space>Cs",
		copilot_disable = "<space>Cd",
		copilot_enable = "<space>Ce",
		copilot_signin = "<space>Ci",
		copilot_signout = "<space>Co",
		copilot_panel = "<space>Cp",
		copilot_save = "<space>Cs",
		copilot_load = "<space>Cl",
		copilot_chat_toggle = "<space>c",
		-- Ask Commands
		copilot_chat_quick_chat = "<C-a>a",
		copilot_chat_ask_select_files = "<C-a>s",
		copilot_chat_stop = "<C-a>S",
		copilot_chat_reset = "<C-a>r",
	},
}

local fzflua = require("fzf-lua")
local kmap = vim.keymap.set
local kopts = function(x) return { noremap = true, silent = true, desc = x or "" } end

local function toggle_copilot(enable)
	enable = enable or false
	if enable then
		vim.cmd([[Copilot enable]])
	else
		vim.cmd([[Copilot disable]])
	end
	vim.cmd([[Copilot status]])
end

local function fzf_select_files_or_quickchat_copilot(active_buffer)
	active_buffer = active_buffer or false
	local opts = {
		prompt = "Add files for Copilot Context (Tab)",
		winopts = {
			width = 0.6,
			row = 0.4,
		},
		actions = {
			["default"] = function(selected)
				if #selected > 0 then
					local files = table.concat(selected, ",")
					vim.ui.input({ prompt = "Chat #files:" .. files }, function(prompt)
						if prompt ~= "" then
							require("CopilotChat").ask("#files:" .. files .. " " .. prompt, {
								selection = require("CopilotChat.select").buffer,
							})
						end
					end)
				end
			end,
		},
	}
	if not active_buffer then
		fzflua.files(opts)
	else
		vim.ui.input({ prompt = "Quickchat #buffer:active: " }, function(prompt)
			if prompt ~= "" then
				require("CopilotChat").ask("#buffer:active " .. prompt, {
					selection = require("CopilotChat.select").buffer,
				})
			end
		end)
	end
end

M.setup = function(opt)
	opts = opts or {}
	M.config.keys = opts.keys or M.config.keys

	-- Render markdown
	require("render-markdown").setup({
		file_types = { "markdown", "copilot-chat" },
	})
	-- Copilot Chat
	require("CopilotChat").setup({
		window = {
			layout = "vertical",
			width = 0.35,
			height = 0.2,
			row = 1,
		},
	})

	-- Keymaps
	kmap("i", M.config.keys.copilot_accept, 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
	kmap("n", M.config.keys.copilot_status, ":Copilot status<CR>",                                                   kopts('Copilot Status'))
	kmap("n", M.config.keys.copilot_disable, function() toggle_copilot() end,                                        kopts('Copilot Toggle'))
	kmap("n", M.config.keys.copilot_enable, function() toggle_copilot(true) end,                                     kopts('Copilot Toggle'))
	kmap("n", M.config.keys.copilot_signin, ":Copilot signin<CR>",                                                   kopts('Copilot Signin'))
	kmap("n", M.config.keys.copilot_signout, ":Copilot signout<CR>",                                                 kopts('Copilot Signout'))
	kmap("n", M.config.keys.copilot_panel, ":Copilot panel<CR>",                                                     kopts('Copilot Panel'))
	kmap("n", M.config.keys.copilot_save, ":CopilotChatSave<CR>",                                                    kopts('CopilotChat Save'))
	kmap("n", M.config.keys.copilot_load, ":CopilotChatLoad<CR>",                                                    kopts('CopilotChat Load'))
	kmap("n", M.config.keys.copilot_chat_toggle, ":CopilotChatToggle<CR>",                                           kopts('CopilotChat Toggle'))
	kmap({ "n", "v", "x" }, M.config.keys.copilot_chat_quick_chat, function()
    fzf_select_files_or_quickchat_copilot(true)
	end,                                                                                                             kopts('CopilotChat Quickchat'))
	-- Select Files for context and Ask
	kmap({ "n", "v", "x" }, M.config.keys.copilot_chat_ask_select_files, function()
		fzf_select_files_or_quickchat_copilot()
	end,                                                                                                             kopts('CopilotChat Select and Ask'))
	kmap({ "n", "v", "x" }, M.config.keys.copilot_chat_stop, ":CopilotChatStop<CR>",                                 kopts('CopilotChat Stop'))
	kmap({ "n", "v", "x" }, M.config.keys.copilot_chat_reset, ":CopilotChatReset<CR>",                               kopts('CopilotChat Reset'))

	-- Do not accept tab for copilot (must come after keymaps)
	vim.g.copilot_no_tab_map = true
end

return M
