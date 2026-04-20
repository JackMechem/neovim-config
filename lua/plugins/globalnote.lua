return {
	"backdround/global-note.nvim",
	keys = {
		{
			"<leader>`",
			function()
				require("global-note").toggle_note()
			end,
			desc = "Toggle global note",
		},
	},
	config = function()
		require("global-note").setup({})
	end,
}
