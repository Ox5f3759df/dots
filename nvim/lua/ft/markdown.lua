-- Autocmd template
local M = {}

M.commands = {}
M.templates = {
  "**$0**"
}

local lang = "Markdown"
local autocmd_patterns = { 'markdown' }
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
            kmap({"n", "v", "x"}, "<F2>", function() templates.insert_snippet(M.templates) end,                                                     kopts('Snippets: Insert'))
            kmap("i", "<F2>", function() templates.insert_snippet(M.templates, true) end,                                                           kopts('Snippets: Insert'))
            kmap("n", "<leader>r", ":RenderMarkdown toggle<CR>",                                                                                    kopts('MarkdownRenderer: Toggle')) -- Render Markdown Toggle
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
