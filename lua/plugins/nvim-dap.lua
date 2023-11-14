return {
	"mfussenegger/nvim-dap",
	config = function()
		vim.keymap.set(
			"n",
			"<leader>db",
			"<cmd> DapToggleBreakpoint <CR>",
			{ silent = true, desc = "Add breakpoaint at line" }
		)
		vim.keymap.set(
			"n",
			"<leader>dr",
			"<cmd> DapContinue <CR>",
			{ silent = true, desc = "Start or continue the debugger" }
		)
	end,
}
