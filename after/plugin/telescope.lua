local status, telescope = pcall(require, "telescope")
if not status then
    return
end

telescope.setup {
    defaults = {
    },
    extensions = {
        file_browser = {
            --theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = false,
            -- mappings = {
            --   ["i"] = {
            --     -- your custom insert mode mappings
            --   },
            --   ["n"] = {
            --     -- your custom normal mode mappings
            --   },
            -- },
        },
    },
}

telescope.load_extension("file_browser")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
vim.keymap.set("n", "<leader>fw", "<CMD>Telescope live_grep<CR>")
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

