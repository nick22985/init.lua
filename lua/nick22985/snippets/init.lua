local modules = { "go", "java" }

for _, name in ipairs(modules) do
	local ok, err = pcall(require, "nick22985.snippets." .. name)
	if not ok then
		vim.notify(("luasnip: failed to load snippets/%s: %s"):format(name, err), vim.log.levels.WARN)
	end
end
