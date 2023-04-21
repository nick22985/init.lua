-- local status, undotre = pcall(require, "undotree")
--  if not status then
--     print("Undotree is not installed")
--   return
-- end

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)


