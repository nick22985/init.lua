local status = pcall(require, "fugitve")
if not status then
  return
end

vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

