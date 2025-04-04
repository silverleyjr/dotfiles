return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup({
				automatic_installation = true,
				ensure_installed = {
					"lua_ls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

			local pumMaps = {
				["<Tab>"] = "<C-n>",
				["<S-Tab>"] = "<C-p>",
				["<Down>"] = "<C-n>",
				["<Up>"] = "<C-p>",
				["<CR>"] = "<C-y>",
			}
			for insertKmap, pumKmap in pairs(pumMaps) do
				vim.keymap.set("i", insertKmap, function()
					return vim.fn.pumvisible() == 1 and pumKmap or insertKmap
				end, { expr = true })
			end

			vim.o.completeopt = "menu,noinsert,popup,fuzzy"
			vim.o.winborder = "rounded"

			vim.keymap.set("i", "<C-.>", function()
				vim.lsp.completion.get()
			end, { noremap = true, silent = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
				end,
			})

			vim.diagnostic.config({
				virtual_lines = true,
			})
		end,
	},
}
