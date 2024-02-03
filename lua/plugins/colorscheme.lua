function ColorMyGruvbox()
	vim.opt.background = "dark"
	vim.opt.termguicolors = true
	vim.cmd.colorscheme("gruvbox")
end

function ColorMyNightfly()
	vim.opt.background = "dark"
	vim.opt.termguicolors = true
	vim.cmd.colorscheme("nightfly")
end

function ColorMyOnedark()
	require("onedark").setup({
		style = "darker",
	})
	require("onedark").load()
	vim.cmd.colorscheme("onedark")
end

return {
	{ "morhetz/gruvbox", name = "gruvbox" },
	{ "bluz71/vim-nightfly-colors", name = "nightfly" },
	{ "navarasu/onedark.nvim", name = "onedark", config = ColorMyOnedark },
	"chrisbra/Colorizer",
	"i3d/vim-jimbothemes",
}
