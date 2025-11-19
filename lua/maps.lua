vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')

-- Markdown Files
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.md" },
	callback = function()
		vim.keymap.set("n", "j", "gj")
		vim.keymap.set("n", "k", "gk")
	end,
})
