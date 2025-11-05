local M = {}

-----------------------------------------------------------------------------------------
-- Placeholders
-- ${cwd}                                     -- fullpath to current working directory
-- ${file}                                    -- relative path to file
-- ${dir}                                     -- relative path to parent directory of current file
-- ${basename}                                -- current filename with extension
-- ${basenameNoExt}                           -- current filename without extension
-- ${fullpath}                                -- fullpath of current file
-- ${fulldir}                                 -- fullpath to parent directory of current file
-----------------------------------------------------------------------------------------
M.expand_placeholders = function(cmd)
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
  else
    cmd = ""
  end
  return cmd
end

return M
