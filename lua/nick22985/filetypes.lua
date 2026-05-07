vim.filetype.add({
	pattern = {
		[".*doop"] = "doop",
		[".*%.ng"] = "html",
		[".env.*"] = "sh",
		["Dockerfile.*"] = "dockerfile",
	},
})
