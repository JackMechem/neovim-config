return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		local material_colors = require("material.colors")

		local theme = require("lualine.themes.material")

		-- Color table for highlights
		-- stylua: ignore
		local colors = {
			bg       = material_colors.editor.bg,
			gray     = material_colors.editor.bg_alt,
			fg       = material_colors.editor.fg,
			yellow   = material_colors.main.yellow,
			cyan     = material_colors.main.cyan,
			darkblue = material_colors.main.paleblue,
			green    = material_colors.main.green,
			orange   = material_colors.main.orange,
			violet   = material_colors.main.purple,
			magenta  = material_colors.main.pink,
			blue     = material_colors.main.blue,
			red      = material_colors.main.red,
		}

		local materialTheme = theme
		materialTheme.inactive.a.bg = colors.bg
		materialTheme.inactive.b.bg = colors.bg
		materialTheme.inactive.c.bg = colors.bg

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
			check_git_workspace = function()
				local filepath = vim.fn.expand("%:p:h")
				local gitdir = vim.fn.finddir(".git", filepath .. ";")
				return gitdir and #gitdir > 0 and #gitdir < #filepath
			end,
		}

		-- Config
		local config = {
			options = {
				-- Disable sections and component separators
				component_separators = "",
				section_separators = "",
				theme = materialTheme,
			},
			sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				-- These will be filled later
				lualine_c = {},
				lualine_x = {},
			},
			inactive_sections = {
				-- these are to remove the defaults
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		-- Inserts a component in lualine_c at left section
		local function ins_left(component)
			table.insert(config.sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_right(component)
			table.insert(config.sections.lualine_x, component)
		end

		local function ins_inac_left(component)
			table.insert(config.inactive_sections.lualine_c, component)
		end

		-- Inserts a component in lualine_x at right section
		local function ins_inac_right(component)
			table.insert(config.inactive_sections.lualine_x, component)
		end

		ins_inac_left({
			function()
				return "▊"
			end,
			color = { fg = colors.gray }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		})

		ins_inac_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.fg },
		})

		ins_inac_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = colors.red },
				warn = { fg = colors.yellow },
				info = { fg = colors.cyan },
			},
		})
		ins_inac_left({
			function()
				return "%="
			end,
		})
		ins_inac_left({ "filetype", color = { fg = colors.fg, gui = "bold" } })
		ins_inac_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " ",
			color = { fg = colors.fg, gui = "bold" },
		})

		-- Add components to right sections
		ins_inac_right({
			"o:encoding", -- option component same as &encoding in viml
			fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_inac_right({
			"fileformat",
			fmt = string.upper,
			icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
			color = { fg = colors.green, gui = "bold" },
		})

		ins_inac_right({
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
		})

		ins_inac_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = "󰝤 ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		ins_inac_right({
			function()
				return "▊"
			end,
			color = { fg = colors.gray },
			padding = { left = 1 },
		})

		ins_left({
			function()
				return "▊"
			end,
			color = { fg = colors.blue }, -- Sets highlighting of component
			padding = { left = 0, right = 1 }, -- We don't need space before this
		})

		ins_left({
			-- mode component
			function()
				return "󰣇"
			end,
			color = function()
				-- auto change color according to neovims mode
				local mode_color = {
					n = colors.blue,
					i = colors.green,
					v = colors.violet,
					[""] = colors.violet,
					V = colors.violet,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					[""] = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}
				return { fg = mode_color[vim.fn.mode()] }
			end,
			padding = { right = 1 },
		})

		ins_left({
			"filetype",
			icon_only = true,
			padding = { left = 2 },
		})

		ins_left({
			"filename",
			cond = conditions.buffer_not_empty,
			color = { fg = colors.blue, gui = "bold" },
			padding = { left = 0 },
		})

		ins_left({ "location" })

		ins_left({
			"diagnostics",
			sources = { "nvim_diagnostic" },
			symbols = { error = " ", warn = " ", info = " " },
			diagnostics_color = {
				error = { fg = colors.red },
				warn = { fg = colors.yellow },
				info = { fg = colors.cyan },
			},
		})

		-- Insert mid section. You can make any number of sections in neovim :)
		-- for lualine it's any number greater then 2
		ins_left({
			function()
				return "%="
			end,
		})

		ins_left({
			-- Lsp server name .
			function()
				local msg = "No Active Lsp"
				local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return msg
				end
				for _, client in ipairs(clients) do
					local filetypes = client.config.filetypes
					if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
						return client.name
					end
				end
				return msg
			end,
			icon = " ",
			color = { fg = colors.fg, gui = "bold" },
		})

		-- Add components to right sections
		ins_right({
			"o:encoding", -- option component same as &encoding in viml
			fmt = string.upper, -- I'm not sure why it's upper case either ;)
			cond = conditions.hide_in_width,
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"fileformat",
			fmt = string.upper,
			icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
			color = { fg = colors.green, gui = "bold" },
		})

		ins_right({
			"branch",
			icon = "",
			color = { fg = colors.violet, gui = "bold" },
		})

		ins_right({
			"diff",
			-- Is it me or the symbol for modified us really weird
			symbols = { added = " ", modified = "󰝤 ", removed = " " },
			diff_color = {
				added = { fg = colors.green },
				modified = { fg = colors.orange },
				removed = { fg = colors.red },
			},
			cond = conditions.hide_in_width,
		})

		ins_right({
			function()
				return "▊"
			end,
			color = { fg = colors.blue },
			padding = { left = 1 },
		})

		-- Now don't forget to initialize lualine
		lualine.setup(config)
	end,
}
