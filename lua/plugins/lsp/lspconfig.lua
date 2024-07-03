-- I stole this from alexjercan/nvim.dotfiles, good job

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
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
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

			-- technically these are "diagnostic signs"
			-- neovim enables them by default.
			-- here we are just changing them to fancy icons.
			lsp_zero.set_sign_icons({ error = " ", warn = " ", hint = "󰠠 ", info = " " })

			require("mason").setup({})
			require("mason-lspconfig").setup({
				handlers = {
					lsp_zero.default_setup,
				},
			})

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

-- return {
-- 	"neovim/nvim-lspconfig",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	dependencies = {
-- 		"hrsh7th/cmp-nvim-lsp",
-- 		{ "antosha417/nvim-lsp-file-operations", config = true },
-- 		"nvim-lua/plenary.nvim",
-- 	},
-- 	config = function()
-- 		-- import lspconfig plugin
-- 		local lspconfig = require("lspconfig")
--
-- 		-- import cmp-nvim-lsp plugin
-- 		local cmp_nvim_lsp = require("cmp_nvim_lsp")
--
-- 		local keymap = vim.keymap -- for conciseness
--
-- 		local opts = { noremap = true, silent = true }
-- 		local on_attach = function(client, bufnr)
-- 			opts.buffer = bufnr
--
-- 			-- set keybinds
-- 			opts.desc = "Show LSP references"
-- 			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
--
-- 			opts.desc = "Go to declaration"
-- 			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
--
-- 			opts.desc = "Show LSP definitions"
-- 			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
--
-- 			opts.desc = "Show LSP implementations"
-- 			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
--
-- 			opts.desc = "Show LSP type definitions"
-- 			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
--
-- 			opts.desc = "See available code actions"
-- 			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
--
-- 			opts.desc = "Smart rename"
-- 			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
--
-- 			opts.desc = "Show buffer diagnostics"
-- 			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
--
-- 			opts.desc = "Show line diagnostics"
-- 			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
--
-- 			opts.desc = "Go to previous diagnostic"
-- 			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
--
-- 			opts.desc = "Go to next diagnostic"
-- 			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
--
-- 			opts.desc = "Show documentation for what is under cursor"
-- 			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
--
-- 			opts.desc = "Restart LSP"
-- 			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
-- 		end
--
-- 		-- used to enable autocompletion (assign to every lsp server config)
--
-- 		local capabilities = cmp_nvim_lsp.default_capabilities()
-- 		-- capabilities.textDocument.completion.completionItem.snippetSupport = false
-- 		-- Change the Diagnostic symbols in the sign column (gutter)
-- 		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
-- 		for type, icon in pairs(signs) do
-- 			local hl = "DiagnosticSign" .. type
-- 			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
-- 		end
--
-- 		-- configure html server
-- 		lspconfig["html"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure typescript server with plugin
-- 		lspconfig["tsserver"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure css server
-- 		lspconfig["cssls"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure tailwindcss server
-- 		lspconfig["tailwindcss"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure svelte server
-- 		lspconfig["svelte"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = function(client, bufnr)
-- 				on_attach(client, bufnr)
--
-- 				vim.api.nvim_create_autocmd("BufWritePost", {
-- 					pattern = { "*.js", "*.ts" },
-- 					callback = function(ctx)
-- 						if client.name == "svelte" then
-- 							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
-- 						end
-- 					end,
-- 				})
-- 			end,
-- 		})
--
-- 		-- configure prisma orm server
-- 		lspconfig["prismals"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure graphql language server
-- 		lspconfig["graphql"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
-- 		})
--
-- 		-- configure emmet language server
-- 		lspconfig["emmet_ls"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
-- 		})
--
-- 		-- configure python server
-- 		lspconfig["pyright"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 		})
--
-- 		-- configure lua server (with special settings)
-- 		lspconfig["lua_ls"].setup({
-- 			capabilities = capabilities,
-- 			on_attach = on_attach,
-- 			settings = { -- custom settings for lua
-- 				Lua = {
-- 					-- make the language server recognize "vim" global
-- 					diagnostics = {
-- 						globals = { "vim" },
-- 					},
-- 					workspace = {
-- 						-- make language server aware of runtime files
-- 						library = {
-- 							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
-- 							[vim.fn.stdpath("config") .. "/lua"] = true,
-- 						},
-- 					},
-- 				},
-- 			},
-- 		})
-- 	end,
-- }
