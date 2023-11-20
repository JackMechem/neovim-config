return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("harpoon").setup({
			global_settings = {
				save_on_toggle = false,
				save_on_change = true,
				enter_on_sendcmd = false,
				tmux_autoclose_windows = false,
				excluded_filetypes = { "harpoon" },
				mark_branch = true,
				tabline = false,
				tabline_prefix = "   ",
				tabline_suffix = "   ",
			},
		})

		require("telescope").load_extension("harpoon")
		local harpoonUi = require("harpoon.ui")
		local harpoonMark = require("harpoon.mark")

		vim.keymap.set("n", "<leader>hm", harpoonUi.toggle_quick_menu, { desc = "Harpoon: Toggle Menu" })
		vim.keymap.set("n", "<leader>hx", harpoonMark.add_file, { desc = "Harpoon: Mark File" })
		vim.keymap.set("n", "<leader>hn", harpoonUi.nav_next, { desc = "Harpoon: Next" })
		vim.keymap.set("n", "<leader>hp", harpoonUi.nav_prev, { desc = "Harpoon: Previous" })
	end,
}
