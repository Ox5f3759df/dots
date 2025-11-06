local M = {}

-- [mini.deps]
-- Added a few mini.deps for vim motion replacements and enhancements
--
-- [mini.surround]
-- `sd[input]` -- delete surrounding input (e.g. {} () [])
-- input: t for tag
-- input: f for function
--  `sr[input][new]`: replace surrounding input
--  `sf[input]`: find surrounding input
--  `sh[input]`: highlight surrounding input
--
-- [mini.jump]: fb,FB -- jump forward, backwards, jump forward-till backwards-till
--
-- [mini.jump2d]: enter -- similar to easymotion, char select
--
-- [mini.splitjoin]: sj -- toggle split/join of code structures

local function setup_plugin_mini_editor()
  -- mini.jump
  require('mini.jump').setup({
    mappings = {
      -- forward = '<CR>',
      forward = 'f',
      backward = 'b',
      forward_till = 'F',
      backward_till = 'B',
      -- repeat_jump = '=',
      repeat_jump = '',
    },
  })

  -- mini.jump2d
  require('mini.jump2d').setup({
    mappings = {
      -- start_jumping = 'f',
      start_jumping = '<CR>',
    }
  })

  -- mini.pairs
  require('mini.pairs').setup()

  -- mini.splitjoin
  require('mini.splitjoin').setup({
    mappings = {
      toggle = 'sj',
      split = '',
      join = '',
    },
  })

  -- mini.surround
  require('mini.surround').setup()

end

M.setup = function(opt)
  opt = opt or {}
  setup_plugin_mini_editor()
end

return M
