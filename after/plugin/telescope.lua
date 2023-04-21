local status, telescope = pcall(require, "telescope")
if not status then
    print("test")
  return
end

print("telescope")
telescope.setup({
  defaults = {
    -- file_ignore_patterns = { "node_modules", ".git" },
  },
  extensions = {
    file_browser = {
        theme = 'ivy',
        hjack_netrw = true,
        mappings = {
            ["i"] = {
            },
            ["n"] = {
            },
        }
    }
  }
})

telescope.load_extension("file_browser")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

vim.keymap.set("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
vim.keymap.set("n", "<leader>fw", "<CMD>Telescope live_grep<CR>")

