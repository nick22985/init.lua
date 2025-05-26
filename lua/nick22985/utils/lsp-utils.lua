local M = {}

--- Read and parse package.json from the given root directory
--- @param root string
--- @return table|nil
local function get_package_json(root)
	if not root then
		return nil
	end

	local path = root .. "/package.json"
	local ok, content = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end

	local ok2, parsed = pcall(vim.json.decode, table.concat(content, "\n"))

	if not ok2 then
		return nil
	end

	return parsed
end

--- Check if the project is a Vue 3 project
--- @param root string
--- @return boolean
M.is_vue3_project = function(root)
	local pkg = get_package_json(root)
	if not pkg then
		return false
	end

	local vue_version = pkg.dependencies and pkg.dependencies.vue or pkg.devDependencies and pkg.devDependencies.vue

	return vue_version and (vue_version:match("^3") or vue_version:match("^%^3")) or false
end

--- Check if the project is an Angular project
--- @param root string
--- @return boolean
M.is_angular_project = function(root)
	local pkg = get_package_json(root)

	if not pkg then
		return false
	end

	return (pkg.dependencies and pkg.dependencies["@angular/core"])
		or (pkg.devDependencies and pkg.devDependencies["@angular/core"]) and true
		or false
end

--- Check if the project uses ESLint
--- @param root string
--- @return boolean
M.is_eslint_project = function(root)
	local pkg = get_package_json(root)
	if not pkg then
		return false
	end

	return (pkg.dependencies and pkg.dependencies.eslint)
		or (pkg.devDependencies and pkg.devDependencies.eslint) and true
		or false
end

return M
