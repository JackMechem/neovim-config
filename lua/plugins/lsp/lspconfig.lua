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
	-- 	rust_analyzer = {
	-- 		settings = {
	-- 			["rust-analyzer"] = {
	-- 				diagnostics = {
	-- 					enable = true,
	-- 					experimental = { enable = true },
	-- 				},
	-- 				check = {
	-- 					command = "clippy",
	-- 					extraArgs = { "--all-targets", "--all-features" },
	-- 				},
	-- 				cargo = {
	-- 					buildScripts = { enable = true },
	-- 					features = "all",
	-- 				},
	-- 				procMacro = {
	-- 					enable = true,
	-- 					ignored = {
	-- 						["async-trait"] = { "async_trait" },
	-- 						["napi-derive"] = { "napi" },
	-- 					},
	-- 				},
	-- 				inlayHints = {
	-- 					bindingModeHints = { enable = true },
	-- 					chainingHints = { enable = true },
	-- 					closureCaptureHints = { enable = true },
	-- 					closureReturnTypeHints = { enable = "always" },
	-- 					expressionAdjustmentHints = { enable = "always" },
	-- 					lifetimeElisionHints = {
	-- 						enable = "skip_trivial",
	-- 						useParameterNames = true,
	-- 					},
	-- 					parameterHints = { enable = true },
	-- 					reborrowHints = { enable = "always" },
	-- 					typeHints = {
	-- 						enable = true,
	-- 						hideClosureInitialization = false,
	-- 						hideNamedConstructor = false,
	-- 					},
	-- 				},
	-- 				imports = {
	-- 					granularity = { group = "module" },
	-- 					prefix = "self",
	-- 				},
	-- 				completion = {
	-- 					privateEditable = { enable = true },
	-- 					fullFunctionSignatures = { enable = true },
	-- 				},
	-- 			},
	-- 		},
	-- 	},
}

local LSP_BINARIES = {
	["nil_ls"] = "nil",
	lua_ls = "lua-language-server",
	ts_ls = "typescript-language-server",
	clangd = "clangd",
	jdtls = "jdtls",
	--rust_analyzer = "rust-analyzer",
	pyright = "pyright",
	gopls = "gopls",
	bashls = "bash-language-server",
	jsonls = "vscode-json-language-server",
	html = "vscode-html-language-server",
	cssls = "vscode-css-language-server",
	zls = "zls",
	marksman = "marksman",
	taplo = "taplo",
	svelte = "svelteserver",
	astro = "astro-ls",
	tailwindcss = "tailwindcss-language-server",
	dockerls = "docker-langserver",
	yamlls = "yaml-language-server",
	kotlin_language_server = "kotlin-language-server",
}

local function enable_available_lsps()
	for server, binary in pairs(LSP_BINARIES) do
		if vim.fn.executable(binary) == 1 then
			local config = LSP_SERVERS[server] or {}
			vim.lsp.config(server, {
				settings = config.settings or {},
				init_options = config.init_options or {},
			})
			vim.lsp.enable(server)
		end
	end
end

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
				local map = function(mode, key, fn, desc)
					vim.keymap.set(mode, key, fn, { buffer = bufnr, remap = false, desc = desc })
				end

				local keymaps = {
					-- { mode, key, fn, desc }
					-- Navigation
					{
						"n",
						"gd",
						vim.lsp.buf.definition,
						"Go to definition",
					},
					{
						"n",
						"gD",
						vim.lsp.buf.declaration,
						"Go to declaration",
					},
					{
						"n",
						"gi",
						vim.lsp.buf.implementation,
						"Go to implementation",
					},
					{
						"n",
						"gt",
						vim.lsp.buf.type_definition,
						"Go to type definition",
					},
					{
						"n",
						"<leader>vrr",
						vim.lsp.buf.references,
						"List references",
					},
					-- Info
					{
						"n",
						"K",
						vim.lsp.buf.hover,
						"Hover documentation",
					},
					{
						"i",
						"<C-h>",
						vim.lsp.buf.signature_help,
						"Signature help",
					},
					{
						"n",
						"<C-h>",
						vim.lsp.buf.signature_help,
						"Signature help",
					},
					-- Refactor
					{
						"n",
						"<leader>vrn",
						vim.lsp.buf.rename,
						"Rename symbol",
					},
					{
						"n",
						"<leader>vca",
						vim.lsp.buf.code_action,
						"Code action",
					},
					{
						"v",
						"<leader>vca",
						vim.lsp.buf.code_action,
						"Code action (range)",
					},
					-- Diagnostics
					{
						"n",
						"<leader>ld",
						vim.diagnostic.open_float,
						"Line diagnostics",
					},
					{
						"n",
						"]d",
						vim.diagnostic.goto_next,
						"Next diagnostic",
					},
					{
						"n",
						"[d",
						vim.diagnostic.goto_prev,
						"Prev diagnostic",
					},
					{
						"n",
						"]e",
						function()
							vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
						end,
						"Next error",
					},
					{
						"n",
						"[e",
						function()
							vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
						end,
						"Prev error",
					},
					{
						"n",
						"<leader>vd",
						vim.diagnostic.setloclist,
						"Diagnostics (loclist)",
					},
					-- Workspace / Symbols
					{
						"n",
						"<leader>vws",
						vim.lsp.buf.workspace_symbol,
						"Workspace symbols",
					},
					{
						"n",
						"<leader>vds",
						vim.lsp.buf.document_symbol,
						"Document symbols",
					},
					-- Codelens
					{
						"n",
						"<leader>vcr",
						vim.lsp.codelens.refresh,
						"Codelens refresh",
					},
					{
						"n",
						"<leader>vcc",
						vim.lsp.codelens.run,
						"Codelens run",
					},
					-- Misc
					{
						"n",
						"<leader>vrs",
						function()
							vim.lsp.buf.format({ async = true })
						end,
						"Format buffer",
					},
					{
						"n",
						"<leader>vrx",
						function()
							vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = bufnr }))
						end,
						"Stop LSP clients",
					},
				}

				for _, km in ipairs(keymaps) do
					map(km[1], km[2], km[3], km[4])
				end

				-- Show all LSP keymaps in a floating window
				map("n", "<leader>v?", function()
					local col_width = 16
					local lines = {
						"  LSP Keymaps",
						"  " .. string.rep("─", 44),
						"  Navigation",
						"  Diagnostics",
						"  Refactor / Info",
						"  Workspace",
						"  Misc",
					}
					-- rebuild as formatted list grouped by category
					local sections = {
						{ "Navigation", { "gd", "gD", "gi", "gt", "<leader>vrr" } },
						{ "Info", { "K", "<C-h>" } },
						{ "Refactor", { "<leader>vrn", "<leader>vca" } },
						{ "Diagnostics", { "<leader>ld", "]d", "[d", "]e", "[e", "<leader>vd" } },
						{ "Workspace", { "<leader>vws", "<leader>vds" } },
						{ "Codelens", { "<leader>vcr", "<leader>vcc" } },
						{ "Misc", { "<leader>vrs", "<leader>vrx" } },
					}
					local lookup = {}
					for _, km in ipairs(keymaps) do
						lookup[km[2]] = km[4]
					end
					local out = { "", "  LSP Keymaps", "  " .. string.rep("─", 44) }
					for _, section in ipairs(sections) do
						table.insert(out, "")
						table.insert(out, "  " .. section[1])
						for _, key in ipairs(section[2]) do
							local desc = lookup[key] or ""
							local pad = string.rep(" ", math.max(1, col_width - #key))
							table.insert(out, string.format("    %-2s%-14s  %s", "", key .. pad, desc))
						end
					end
					table.insert(out, "")

					local width = 52
					local height = #out
					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
					vim.bo[buf].modifiable = false
					vim.api.nvim_open_win(buf, true, {
						relative = "editor",
						width = width,
						height = height,
						row = math.floor((vim.o.lines - height) / 2),
						col = math.floor((vim.o.columns - width) / 2),
						style = "minimal",
						border = "rounded",
						title = " LSP Keymaps ",
						title_pos = "center",
					})
					vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
					vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })
				end, "Show all LSP keymaps")
			end)

			-- Diagnostic Icons
			lsp_zero.set_sign_icons({ error = " ", warn = " ", hint = "󰠠 ", info = " " })

			enable_available_lsps()

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
