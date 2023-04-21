local status, galaxyline = pcall(require, "galaxyline")
if not status then
    return
end
require('galaxyline.themes.eviline')


-- galaxyline.section.left[1] = {
--     ViMode = {
--         provider = function()
--             local alias = {
--                 n = "NORMAL",
--                 i = "INSERT",
--                 c = "COMMAND",
--                 V = "VISUAL",
--                 [""] = "VISUAL",
--                 v = "VISUAL",
--                 R = "REPLACE"
--             }
--             return alias[vim.fn.mode()]
--         end,
--         separator = " ",
--     }
-- }
--
