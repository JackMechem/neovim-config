return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	dependencies = { "folke/snacks.nvim" },
	config = function()
		vim.g.opencode_opts = {
			provider = {
				name = "openai",
				model = "qwen2.5-coder:32b",
				base_url = "http://127.0.0.1:11434/v1",
				api_key = "ollama",
			},
		}

		vim.o.autoread = true

		local o = require("opencode")

		vim.keymap.set({ "n", "x" }, "<leader>oa", function()
			o.ask("@this: ", { submit = true })
		end, { desc = "Ask opencode" })

		vim.keymap.set({ "n", "x" }, "<leader>ox", function()
			o.select()
		end, { desc = "Execute opencode action" })

		vim.keymap.set({ "n", "x" }, "<leader>oo", function()
			o.toggle()
		end, { desc = "Toggle opencode" })

		vim.keymap.set({ "n", "x" }, "go", function()
			return o.operator("@this ")
		end, { desc = "Add range to opencode", expr = true })

		vim.keymap.set("n", "goo", function()
			return o.operator("@this ") .. "_"
		end, { desc = "Add line to opencode", expr = true })
	end,
	keys = {
		{ "<leader>o", nil, desc = "Opencode" },
		{ "<leader>oo", desc = "Toggle opencode" },
		{ "<leader>oa", desc = "Ask opencode" },
		{ "<leader>ox", desc = "Execute opencode action" },
	},
}
