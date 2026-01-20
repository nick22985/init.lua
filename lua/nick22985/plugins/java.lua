return {
	{
		"mfussenegger/nvim-jdtls",
		config = function()
			local jdtls = require("jdtls")

			local root_dir = jdtls.setup.find_root({ ".git", "pom.xml", "build.gradle" })

			local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspaces/") .. vim.fn.fnamemodify(root_dir, ":p:h:t")
			vim.fn.mkdir(workspace_dir, "p")

			local config = {
				cmd = {
					"jdtls",
					"-data",
					workspace_dir,
				},
				root_dir = root_dir,
				settings = {
					java = {
						eclipse = { downloadSources = true },
						maven = { downloadSources = true },
						implementationsCodeLens = { enabled = true },
						referencesCodeLens = { enabled = true },
						inlayHints = { parameterNames = { enabled = "all" } },
					},
				},
			}

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					jdtls.start_or_attach(config)
				end,
			})
		end,
	},
}
