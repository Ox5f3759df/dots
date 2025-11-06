local M = {}

local config = {
	storage_dir = vim.fn.expand("~/.vim/cache"),
}

local function contains(table, value)
	for _, v in ipairs(table) do
		if v == value then
			return true
		end
	end
	return false
end

local function get_storage_filepath()
	-- Make directory if it doesn't exist
	vim.fn.mkdir(config.storage_dir, "p")
	local filepath = vim.fn.expand("%:p")
	local normalized = filepath:gsub("^~?/", ""):gsub("/", "_")
	return config.storage_dir .. "/" .. normalized .. ".json"
end

-- Read storage if it exists otherwise return empty table
M.get_storage_table = function()
	local filepath = get_storage_filepath()
	local storage = {}
	local file_exists = vim.loop.fs_stat(filepath)
	if not file_exists then
		local json_str = vim.fn.json_encode(storage)
		local f = io.open(filepath, "w")
		if f then
			f:write(json_str)
			f:close()
		end
	else
		local f = io.open(filepath, "r")
		local content = f:read("*a")
		storage = vim.fn.json_decode(content) or {}
		f:close()
	end
	return storage
end

M.write_storage_table = function(storage, filepath)
	local filepath = filepath or get_storage_filepath()
	local f = io.open(filepath, "w")
	if f then
		local json_str = vim.fn.json_encode(storage)
		f:write(json_str)
		f:close()
	end
end

M.write_storage_key_list = function(key, value)
	local storage = M.get_storage_table()
	if storage[key] == nil then
		storage[key] = {}
	end
	if value ~= nil and not contains(storage[key], value) then
		table.insert(storage[key], value)
		M.write_storage_table(storage)
	end
	return table
end

M.read_storage_key_list = function(key)
	local storage = M.get_storage_table()
	return storage[key] or {}
end

M.read_storage_key_list_latest = function(key)
	local storage_key = M.read_storage_key_list(key) or {}
	return storage_key[#storage_key]
end

function M.setup(opts)
	opts = opts or {}
	config.storage_dir = opts.storage_dir or config.storage_dir
end

return M
