return {
	{
		"nvim-treesitter/nvim-treesitter",

		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		event = { "BufReadPre", "BufNewFile" },
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			autotag = {
				enable = true,
			},
			-- A list of parser names, or "all"
			ensure_installed = { "lua", "javascript", "typescript" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- `false` will disable the whole extension
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			indent = { enable = true },
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	"nvim-treesitter/playground",
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

-- return {
--   {
--     "nvim-treesitter/nvim-treesitter",
--     event = { "BufReadPre", "BufNewFile" },
--     build = ":TSUpdate",
--     dependencies = {
--       "nvim-treesitter/nvim-treesitter-textobjects",
--       "windwp/nvim-ts-autotag",
--     },
--     config = function()
--       -- import nvim-treesitter plugin
--       local treesitter = require("nvim-treesitter.configs")
--
--       -- configure treesitter
--       treesitter.setup({ -- enable syntax highlighting
--         highlight = {
--           enable = true,
--         },
--         -- enable indentation
--         indent = { enable = true },
--         -- enable autotagging (w/ nvim-ts-autotag plugin)
--         autotag = {
--           enable = true,
--         },
--         -- ensure these language parsers are installed
--         ensure_installed = {
--           "json",
--           "javascript",
--           "typescript",
--           "tsx",
--           "yaml",
--           "html",
--           "css",
--           "prisma",
--           "markdown",
--           "markdown_inline",
--           "svelte",
--           "graphql",
--           "bash",
--           "lua",
--           "vim",
--           "dockerfile",
--           "gitignore",
--           "query",
--         },
--         incremental_selection = {
--           enable = true,
--           keymaps = {
--             init_selection = "<C-space>",
--             node_incremental = "<C-space>",
--             scope_incremental = false,
--             node_decremental = "<bs>",
--           },
--         },
--         -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
--         context_commentstring = {
--           enable = true,
--           enable_autocmd = false,
--         },
--       })
--     end,
--   },
-- }
