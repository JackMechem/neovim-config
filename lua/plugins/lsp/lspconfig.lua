local LSP_SERVERS = {
	["nil_ls"] = { settings = {
		["nil"] = { formatting = { command = { "nixfmt", "--indent=4" } } },
	} },
	lua_ls = {
		settings = {
			Lua = { format = { defaultConfig = { indent_style = "space", indent_size = "4" } } },
		},
	},
	ts_ls = {
		settings = {
			javascript = { format = { indentSize = 4, tabSize = 4 } },
			typescript = { format = { indentSize = 4, tabSize = 4 } },
		},
	},
	clangd = {
		init_options = { fallbackFlags = { "--indent-width=4" } },
	},
	jdtls = {
		settings = {
			java = {
				format = {
					enabled = true,
				},
			},
		},
	},
}

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "neovim/nvim-lspconfig" },
			{ "L3MON4D3/LuaSnip" },
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "rafamadriz/friendly-snippets" },
			{ "onsails/lspkind.nvim" },
		},
		branch = "v3.x",
		config = function()
			local lsp_zero = require("lsp-zero")
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>ld", function()
					vim.diagnostic.open_float()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>vcr", function()
					vim.lsp.codelens.refresh()
				end, opts)
				vim.keymap.set("n", "<leader>vcc", function()
					vim.lsp.codelens.run()
				end, opts)
				vim.keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, opts)
				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end)

			-- Diagnostic Icons
			lsp_zero.set_sign_icons({ error = " ", warn = " ", hint = "󰠠 ", info = " " })

			for name, config in pairs(LSP_SERVERS) do
				vim.lsp.config(name, {
					settings = config.settings or {},
					init_options = config.init_options or {},
				})
				vim.lsp.enable(name)
			end

			local cmp = require("cmp")
			local cmp_action = require("lsp-zero").cmp_action()
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#FF0000" })

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
					{ name = "buffer", keyword_length = 3 },
					{ name = "path" },
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:bg,FloatBorder:bg,Search:None",
						col_offset = -4,
						side_padding = 0,
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:bg,FloatBorder:bg,Search:None",
						col_offset = -4,
						side_padding = 0,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, vim_item)
						local kind =
							require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<Return>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = nil,
					["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
					["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
				}),
			})
		end,
	},
}
