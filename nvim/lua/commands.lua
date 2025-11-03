local M = {}

local fzflua = require('fzf-lua')
local storage = require("storage")
local storage_root_key = "commands"
local storage_watchpaths_key = "watchpaths"
local toggleterm = require("toggleterm")
local Terminal = require('toggleterm.terminal').Terminal

M.terms = {}

M.config = {
  keys = {
    ask_cmd = "<leader>x",
    ask_watchman_cmd = "<leader>W",
    toggleterm_cmd = "tt",
    select_cmd = "<leader>c",
    select_watchman_cmd = "<leader>w",
    run_single = "<leader>r",
    kill_terminal_cmd = "<leader>d"
  },
  run_single_idx = 1, -- Index in the commands that runs single file
  side = "bottom", -- "bottom", "left", or "right"
  sizes = {
    right = nil,  -- if nil => half screen, else numeric width
    bottom = nil, -- if nil => default_height, else numeric height
  },
  default_bottom_size = 12, -- default height when bottom is used
  default_right_size = 90,
}

-----------------------------------------------------------------------------------------
-- Placeholders
-- ${file}                                    -- relative path to file
-- ${dir}                                     -- relative path to parent directory of current file
-- ${basename}                                -- current filename with extension
-- ${basenameNoExt}                           -- current filename without extension
-- ${fullpath}                                -- fullpath of current file
-- ${fulldir}                                 -- fullpath to parent directory of current file
-- ${input:NAME}                              -- prompt user for input with prompt NAME
local function expand_placeholders(cmd)
  if cmd ~= nil then
    local cwd = vim.fn.getcwd()                         -- current working directory
    local full = vim.fn.expand("%:p")                   -- full path
    local filename = vim.fn.expand("%:t")               -- file name with ext
    local basename = vim.fn.expand("%:t:r")             -- filename without ext
    local rel = vim.fn.fnamemodify(full, ":.")          -- relative to cwd
    local fulldir = vim.fn.expand("%:p:h")              -- full path to parent directory
    local rel_dir = vim.fn.fnamemodify(fulldir, ":.")   -- parent directory relative to cwd

    cmd = cmd:gsub("%${cwd}", vim.fn.shellescape(cwd))
    cmd = cmd:gsub("%${file}", vim.fn.shellescape(rel))
    cmd = cmd:gsub("%${basename}", vim.fn.shellescape(filename))
    cmd = cmd:gsub("%${basenameNoExt}", vim.fn.shellescape(basename))
    cmd = cmd:gsub("%${fullpath}", vim.fn.shellescape(full))
    cmd = cmd:gsub("%${fulldir}", vim.fn.shellescape(fulldir))
    cmd = cmd:gsub("%${dir}", vim.fn.shellescape(rel_dir))

    -- collect unique input placeholders,
    -- prompt once per name, then replace all occurrences
    local inputs = {}
    for name in cmd:gmatch("%${input:([^}]+)}") do
      inputs[name] = true
    end
    for name,_ in pairs(inputs) do
      local val = vim.fn.input(name .. ": ")
      cmd = cmd:gsub("%${input:" .. vim.pesc(name) .. "}", vim.fn.shellescape(val))
    end
  else
    cmd = ""
  end
  return cmd
end

local function table_count(tbl)
  local count = 0
  for _ in pairs(M.terms) do
    count = count + 1
  end
  return count
end

M.run_in_terminal_single = function(cmd)
  vim.ui.input({ prompt = "Watch (y/n): " }, function(inputw)
    local should_watch = inputw == "y"
    if should_watch then
      inputw = "${file}"
    else
      inputw = ""
    end
    local watchman_paths = expand_placeholders(inputw)
    M.run_in_terminal(cmd, watchman_paths)
  end)
end

M.run_in_terminal = function(cmd, watchman_paths)
  local fullpath = vim.fn.expand("%:p")
  local prev_term_exists = false
  for fp, _ in pairs(M.terms) do
    vim.notify("fp: " .. fp .. " fullpath: " .. fullpath)
    if fp == fullpath then
      prev_term_exists = true
      break
    end
  end

  watchman_paths = watchman_paths or ""
  if cmd == nil or cmd == "" then return end
  storage.write_storage_key_list(storage_root_key, cmd)
  cmd = expand_placeholders(cmd)
  cmd = cmd:gsub("'", "")
  if watchman_paths ~= "" then
    watchman_paths = watchman_paths:gsub("'", "")
    cmd = 'watchman-make -p "' .. watchman_paths .. '" -r "clear; ' .. cmd .. '"'
  end

  local direction = "horizontal"
  local size = M.config.sizes.bottom
  if M.config.side == "right" then
    direction = "vertical"
    size = M.config.sizes.right
  end

  if prev_term_exists and M.terms[fullpath] ~= nil then
    vim.notify("Shutting down! for " .. fullpath)
    M.terms[fullpath]:close()
    M.terms[fullpath]:shutdown()
    M.terms[fullpath] = nil
  end

  local term = Terminal:new({
    direction = direction,
    display_name = cmd,
    on_open = function(_)
      vim.cmd("stopinsert")
    end
  })
  term:toggle(size, direction)
  vim.notify("Command run: " .. cmd)
  term:send(cmd)
  if M.config.side == "right" then
    vim.cmd("wincmd h")
  else
    vim.cmd("wincmd k")
  end
  M.terms[fullpath] = term
end

local function toggle_terminal()
  vim.cmd("ToggleTermToggleAll")
  if M.config.side == "right" then
    vim.cmd("wincmd h")
  else
    vim.cmd("wincmd k")
  end
end

M.fzf_delete_terminal = function()
  local fps = {}
  for fp, _ in pairs(M.terms) do
    table.insert(fps, fp)
  end
  local opts = {
    prompt = "Select Terminal to Delete ",
    winopts = {
      width = 0.6,
      row = 0.4,
    },
    actions = {
      ["default"] = function(selected)
        local selected_fp = selected[1]
        if M.terms[selected_fp] ~= nil then
          vim.notify("Shutting down! for " .. selected_fp)
          M.terms[selected_fp]:close()
          M.terms[selected_fp]:shutdown()
          M.terms[selected_fp] = nil
        end
      end,
    },
  }
  fzflua.fzf_exec(fps, opts)
end

M.fzf_command_picker = function(language_commands, watchman_paths)
  if #language_commands == 1 then
    M.run_in_terminal(language_commands[1], watchman_paths)
    return
  end
  local opts = {
    prompt = "Select Command ",
    winopts = {
      width = 0.6,
      row = 0.4,
    },
    actions = {
      ["default"] = function(selected)
        local command = selected[1]
        M.run_in_terminal(command, watchman_paths)
      end,
    },
  }
  fzflua.fzf_exec(language_commands, opts)
end

M.ask_and_run = function()
  local default_cmd = storage.read_storage_key_list_latest(storage_root_key) or ""
  vim.ui.input({ prompt = "Enter Command: ", default = default_cmd }, function(input)
    M.run_in_terminal(input)
  end)
end

M.watch_pick_and_run = function(language_commands)
  local default_watchmanpaths = storage.read_storage_key_list_latest(storage_watchpaths_key) or ""
  vim.ui.input({ prompt = "Enter watchman paths: ", default = default_watchmanpaths }, function(inputw)
    if inputw ~= nil and inputw ~= "" then
      storage.write_storage_key_list(storage_watchpaths_key, inputw)
      local watchman_paths = expand_placeholders(inputw)
      M.fzf_command_picker(language_commands, watchman_paths)
    end
  end)
end

M.watch_ask_and_run = function()
  local default_watchmanpaths = storage.read_storage_key_list_latest(storage_watchpaths_key) or ""
  vim.ui.input({ prompt = "Enter watchman paths: ", default = default_watchmanpaths }, function(inputw)
    if inputw ~= nil and inputw ~= "" then
      storage.write_storage_key_list(storage_watchpaths_key, inputw)
      local watchman_paths = expand_placeholders(inputw)
      local default_cmd = storage.read_storage_key_list_latest(storage_root_key) or ""
      vim.ui.input({ prompt = "Enter Command: ", default = default_cmd }, function(inputc)
        M.run_in_terminal(inputc, watchman_paths)
      end)
    end
  end)
end

M.setup = function(opts)
  opts = opts or {}
  M.config.keys = opts.keys or M.config.keys
  M.config.side = opts.side or M.config.side
  opts.sizes = opts.sizes or M.config.sizes
  M.config.sizes.right = (opts.sizes.right ~= nil) and opts.sizes.right or M.config.default_right_size
  M.config.sizes.bottom = (opts.sizes.bottom ~= nil) and opts.sizes.bottom or M.config.default_bottom_size

  -- Setup toggleterm
   toggleterm.setup({})

  vim.keymap.set("n", M.config.keys.ask_cmd, function() M.ask_and_run() end, { noremap = true, silent = true })
  vim.keymap.set("n", M.config.keys.ask_watchman_cmd, function() M.watch_ask_and_run() end, { noremap = true, silent = true })
  vim.keymap.set("n", M.config.keys.toggleterm_cmd, function() toggle_terminal() end, { noremap = true, silent = true })
  vim.keymap.set("n", M.config.keys.kill_terminal_cmd, function() M.fzf_delete_terminal() end, { noremap = true, silent = true })
end

return M
