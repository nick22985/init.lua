local ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = require
if ok then
	reloader = plenary_reload.reload_module
end

P = function(v)
	print(vim.inspect(v))
	return v
end

RELOAD = function(...)
	reloader = plenary_reload.reload_module

	return reloader(...)
end

R = function(name)
	RELOAD(name)
	return require(name)
end
