local M = {}
M.commands = {
  "node ${file}"
}
M.templates = {}
local lang = "Javascript"
local autocmd_patterns = { 'javascript' }
local commands = require('commands')
M.autocommands = function()
  local langGroup = vim.api.nvim_create_augroup(lang .. 'Group', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = langGroup,
    pattern = autocmd_patterns,
    callback = function(args)
        vim.api.nvim_create_autocmd('BufEnter', {
          buffer = args.buf,
          callback = function()
            -- vim.notify("Setting autocmds for: " .. lang)
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = args.buf }
            -- Filetype bindings here
            map("n", "<leader>t", ":lua vim.notify('Test autocmd for: " .. lang .. "')<CR>", opts)                                  -- autocmd tester
            map("n", commands.config.keys.select_cmd, function() commands.fzf_command_picker(M.commands) end, opts)                 -- Select command to run   
            map("n", commands.config.keys.select_watchman_cmd, function() commands.watch_pick_and_run(M.commands) end, opts)        -- Select command to watch and run   
            map("n", commands.config.keys.run_single, function() commands.run_in_terminal_single(M.commands[commands.config.run_single_idx]) end, opts) -- Run single
          end,
        })
        -- Exit
        vim.api.nvim_create_autocmd('BufLeave', {
          buffer = args.buf,
          callback = function()
            -- vim.notify("Clearing autocmds for: " .. lang)
          end,
        })
        -- Save
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = args.buf,
          callback = function()
            -- vim.notify("Saving autocmds for: " .. lang)
          end,
        })
    end,
  })
end
return M
