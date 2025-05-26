vim.filetype.add({
	pattern = {
		[".*doop"] = "vue",
		[".*%.ng"] = "html",
		[".env.*"] = "sh",
	},
})
