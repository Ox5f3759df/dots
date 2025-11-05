local M = {}

M.commands = {
  "clear; mkdir -p .bins; bear -- g++ -std=c++2c -g -o .bins/cpp.out ${file} && .bins/cpp.out"
}
M.templates = {
  [[std::cout << "$0" << '\n'; // FIXME]],
  [[std::cout << "Variable $0: " << $0 << '\n'; // FIXME]],
  [[std::cout << "(" << __func__ << ") " << "file: " << __FILE__ << ":" << __LINE__ << '\n'; // FIXME]],
  [[#define LOG() std::cout << "(" << __func__ << ") file: " << __FILE__ << ":" << __LINE__ << '\n';]],

}

local lang = "Cpp"
local autocmd_patterns = { 'cpp' }
local commands = require('commands')
local templates = require('templates')

M.autocommands = function()
  local langGroup = vim.api.nvim_create_augroup(lang .. 'Group', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = langGroup,
    pattern = autocmd_patterns,
    callback = function(args)
        vim.api.nvim_create_autocmd('BufEnter', {
          buffer = args.buf,
          callback = function()
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true, buffer = args.buf }
            -- Filetype bindings here
            map({"n", "v", "x"}, "<F2>", function() templates.insert_snippet(M.templates) end, opts)                                -- Templates
            map("i", "<F2>", function() templates.insert_snippet(M.templates, true) end, opts)                                      -- Templates
            map("n", commands.config.keys.select_cmd, function() commands.fzf_command_picker(M.commands) end, opts)                 -- Select command to run   
            map("n", commands.config.keys.select_watchman_cmd, function() commands.watch_pick_and_run(M.commands) end, opts)        -- Select command to watch and run   
            map("n", commands.config.keys.run_single, function() commands.run_in_terminal_single(M.commands[commands.config.run_single_idx]) end, opts) -- Run single
          end,
        })
        -- Exit
        vim.api.nvim_create_autocmd('BufLeave', {
          buffer = args.buf,
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
