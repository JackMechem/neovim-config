return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		dependencies = {
			"windwp/nvim-ts-autotag",
		},
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			-- main branch puts queries under runtime/queries/ which isn't on rtp by default
			local ts_runtime = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
			if vim.fn.isdirectory(ts_runtime) == 1 then
				vim.opt.runtimepath:prepend(ts_runtime)
			end

			require("nvim-treesitter").setup({
				ensure_installed = {
					"lua", "javascript", "typescript",
					"markdown", "markdown_inline", "rust",
				},
				auto_install = true,
			})

			-- Enable treesitter highlighting for all filetypes
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local ft = vim.bo[ev.buf].filetype
					if ft == "oil" then
						return
					end
					local ok = pcall(vim.treesitter.start, ev.buf)
					if not ok then
						vim.bo[ev.buf].syntax = "on"
					end
				end,
			})

			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		enabled = true,
		opts = { mode = "cursor", max_lines = 3 },
		keys = {
			{
				"<leader>ut",
				function()
					require("treesitter-context").toggle()
				end,
				desc = "Toggle Treesitter Context",
			},
		},
	},
}
