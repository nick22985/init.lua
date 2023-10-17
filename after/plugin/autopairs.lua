local status, autopairs = pcall(require, "nvim-autopairs")
if not status then
	return
end

local Rule = require('nvim-autopairs.rule')



autopairs.setup({
	check_ts = true,
	ts_config = {
		lua = { 'string' }, -- it will not add a pair on that treesitter node
		javascript = { 'template_string' },
	}
})


local ts_conds = require('nvim-autopairs.ts-conds')

-- press % => %% only while inside a comment or string
autopairs.add_rules({
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),
  Rule("$", "$", "lua")
    :with_pair(ts_conds.is_not_ts_node({'function'}))
})
