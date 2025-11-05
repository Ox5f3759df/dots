local M = {}

M.config = {
  wiki_dir = vim.fn.expand("~/Development/Projects/playground/Wiki"),
  daily_dir = os.date("%Y"),
  keys = {
    open_daily_note_cmd = "<leader>d"
  }
}

local kmap = vim.keymap.set
local kopts = function(x) return { noremap = true, silent = true, desc = x or "" } end

M.open_daily_note = function()
  local today = os.date("%Y-%m-%d") 
  local daily_note_dir = M.config.wiki_dir .. "/" .. M.config.daily_dir .. "/" .. today
  -- Make directory if it doesn't exist
  vim.fn.mkdir(daily_note_dir, "p")
  local daily_note_file = daily_note_dir .. "/" .. today .. ".md"
  vim.cmd("edit " .. daily_note_file)
end

function M.setup(opts)
  opts = opts or {}
  M.config.wiki_dir = opts.wiki_dir or M.config.wiki_dir
  M.config.daily_dir = opts.daily_dir or M.config.daily_dir
  M.config.keys = opts.keys or config.keys
  kmap("n", M.config.keys.open_daily_note_cmd, function() M.open_daily_note() end, kopts('Wiki: Daily Note'))
end

return M
