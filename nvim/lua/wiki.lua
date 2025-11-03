local M = {}

local config = {
  wiki_dir = vim.fn.expand("~/Development/Projects/playground/Wiki"),
  daily_dir = os.date("%Y"),
  keys = {
    open_daily_note_cmd = "<leader>d"
  }
}

M.open_daily_note = function()
  local today = os.date("%Y-%m-%d") 
  local daily_note_dir = config.wiki_dir .. "/" .. config.daily_dir .. "/" .. today
  -- Make directory if it doesn't exist
  vim.fn.mkdir(daily_note_dir, "p")
  local daily_note_file = daily_note_dir .. "/" .. today .. ".md"
  vim.cmd("edit " .. daily_note_file)
end

function M.setup(opts)
  opts = opts or {}
  config.wiki_dir = opts.wiki_dir or config.wiki_dir
  config.daily_dir = opts.daily_dir or config.daily_dir
  config.keys = opts.keys or config.keys
  vim.keymap.set("n", config.keys.open_daily_note_cmd, function() M.open_daily_note() end, { noremap = true, silent = true })
end

return M
