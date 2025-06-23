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

--- Check if a file exists in the given directory
--- @param directory string
--- @param file string
--- @return boolean
local function file_exists_in_directory(directory, file)
	return vim.fn.filereadable(vim.fn.expand(directory .. "/" .. file)) == 1
end

--- Find Prettier configuration file starting from a directory and traversing upwards
--- @param starting_directory string|nil Optional starting directory (defaults to current file's directory)
--- @return string Path to the prettier config file
M.get_prettier_config = function(starting_directory)
	local config_files = {
		"package.json",
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.json5",
		".prettierrc.js",
		"prettier.config.js",
		".prettierrc.mjs",
		"prettier.config.mjs",
		".prettierrc.cjs",
		"prettier.config.cjs",
		".prettierrc.toml",
	}

	local function find_config_file(start_dir)
		local current_directory = start_dir or vim.fn.expand("%:p:h")

		local root_directory = vim.fn.getcwd()

		while current_directory ~= "/" do
			for _, file in ipairs(config_files) do
				if file_exists_in_directory(current_directory, file) then
					if file == "package.json" then
						local package_json = get_package_json(current_directory)
						if package_json and package_json["prettier"] then
							return current_directory .. "/" .. file
						end
					else
						return current_directory .. "/" .. file
					end
				end
			end

			if current_directory == root_directory then
				break
			end
			current_directory = vim.fn.fnamemodify(current_directory, ":h")
		end

		-- Return the fallback config if no config files are found
		return os.getenv("HOME") .. "/.config/nvim/utils/linter-config/.prettierrc.json"
	end

	return find_config_file(starting_directory)
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

--- Check if the project uses Prettier
--- @param root string
--- @return boolean
M.is_prettier_project = function(root)
	local pkg = get_package_json(root)
	if not pkg then
		return false
	end
	-- Check if prettier is in dependencies/devDependencies or if there's a prettier config in package.json
	return (pkg.dependencies and pkg.dependencies.prettier)
		or (pkg.devDependencies and pkg.devDependencies.prettier)
		or (pkg.prettier ~= nil) and true
		or false
end

return M
