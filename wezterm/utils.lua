local wezterm = require 'wezterm'
local M = {}

--- Merges two tables, overwriting common elements from table_b
--- @param ... table[]
--- @return table
function M.merge(...)
   local args = table.pack(...)
   local merged = {}

   for i = 1, args.n do
      if type(args[i]) == 'string' then
         error(args[i])
      end
      for k, v in pairs(args[i]) do
         merged[k] = v
      end
   end

   return merged
end

--- @param module string
--- @return any
function M.req(module)
   local m = require(module)
   return m
end

--- Returns a new list with function applied to each element of the list
--- @generic T
--- @generic G
--- @param list T[]
--- @param func fun(t: T): G
--- @return G[]
function M.map(list, func)
   local mapped = {}
   for i, v in ipairs(list) do
      mapped[i] = func(v)
   end

   return mapped
end


function M.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function M.dump(o)
  if type(o) ~= 'table' then return tostring(o) end
  local s = '{ '
  for k,v in pairs(o) do
    s = s .. tostring(k) .. ' = ' .. M.dump(v) .. ', '
  end
  return s .. '}'
end

return M
