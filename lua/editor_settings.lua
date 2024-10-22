--
-- EDITOR SETTINGS
--

-- Variables {{{
local vim = vim
local g = vim.g
local o = vim.o
local set = vim.opt
local bo = vim.bo
local wo = vim.wo

-- }}}

-- Global {{{

g.mapleader = " "

-- }}}

-- General {{{
--
o.background = "dark"
o.termguicolors = true
o.syntax = "on"
o.errorbells = false
o.smartcase = true
o.showmode = false
bo.swapfile = false
o.backup = false
o.undodir = vim.fn.stdpath("config") .. "/undodir"
o.undofile = true
o.incsearch = true
o.hidden = true
o.completeopt = "menuone,noinsert,noselect"
bo.autoindent = true
bo.smartindent = true
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
bo.shiftwidth = 4
wo.number = true
wo.relativenumber = true
wo.signcolumn = "yes"
vim.opt.formatoptions = "jcroqlnt"
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.md" },
	callback = function()
		wo.wrap = true
		-- vim.opt.colorcolumn = "80"
		wo.linebreak = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "*.md" },
	callback = function()
		wo.wrap = false
		-- vim.opt.colorcolumn = "120"
		wo.linebreak = true
	end,
})
o.foldmethod = "marker"
o.cursorline = true

-- }}}
