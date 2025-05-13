local M = {}

M.is_vue3_project = function(root)
	if not root then
		return false
	end

	local package_json_path = root .. "/package.json"
	local ok, package_json = pcall(vim.fn.readfile, package_json_path)

	if not ok then
		return false
	end

	local ok2, parsed = pcall(vim.json.decode, table.concat(package_json, "\n"))

	if not ok2 then
		return false
	end

	local vue_version = nil
	if parsed.dependencies and parsed.dependencies.vue then
		vue_version = parsed.dependencies.vue
	elseif parsed.devDependencies and parsed.devDependencies.vue then
		vue_version = parsed.devDependencies.vue
	end

	return vue_version and (vue_version:match("^3") or vue_version:match("^%^3"))
end

return M
