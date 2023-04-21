local status = pcall(require, "rose-pine")
if not status then
  return
end

function ColorMyPencils(color)
	color = color or "rose-pine"--"onedark"
	vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})

end

ColorMyPencils()
