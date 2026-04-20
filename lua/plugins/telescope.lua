return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		-- Neovim 0.10+ removed vim.treesitter.ft_to_lang
		if not vim.treesitter.ft_to_lang then
			vim.treesitter.ft_to_lang = function(ft)
				local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
				return ok and lang or ft
			end
		end

		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
	end,
}
