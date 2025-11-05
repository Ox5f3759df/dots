
local M = {}

M.commands = {
  "go run ${file}"
}
M.templates = {}

local lang = "Go"
local autocmd_patterns = { 'go' }
local commands = require('commands')
local templates = require('templates')
local kmap = vim.keymap.set
local kopts = function(x) return { noremap = true, silent = true, desc = x or "" } end

M.autocommands = function()
  local langGroup = vim.api.nvim_create_augroup(lang .. 'Group', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = langGroup,
    pattern = autocmd_patterns,
    callback = function(args)
        vim.api.nvim_create_autocmd('BufEnter', {
          buffer = args.buf,
          callback = function()
            -- Filetype bindings here
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = args.buf }
            -- Filetype bindings here
            kmap({"n", "v", "x"}, "<F2>", function() templates.insert_snippet(M.templates) end,                                                     kopts('Snippets: Insert'))
            kmap("i", "<F2>", function() templates.insert_snippet(M.templates, true) end,                                                           kopts('Snippets: Insert'))
            kmap("n", commands.config.keys.select_cmd, function() commands.fzf_command_picker(M.commands) end,                                      kopts('Cmds: Select and Run'))
            kmap("n", commands.config.keys.select_watchman_cmd, function() commands.watch_pick_and_run(M.commands) end,                             kopts('Cmds: Select Watch and Run'))
            kmap("n", commands.config.keys.run_single, function() commands.run_in_terminal_single(M.commands[commands.config.run_single_idx]) end,  kopts('Cmds: Run/Watch Default'))
          end,
        })
        -- Exit
        vim.api.nvim_create_autocmd('BufLeave', {
          buffer = args.buf, -- Also buffer-local
          callback = function()
          end,
        })
        -- Save
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = args.buf,
          callback = function()
          end,
        })
    end,
  })
end

return M
