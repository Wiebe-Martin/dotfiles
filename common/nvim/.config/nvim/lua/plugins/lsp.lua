return {
	-- Main LSP Configuration
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },

		-- Allows extra capabilities provided by nvim-cmp
		"hrsh7th/cmp-nvim-lsp",

		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			opts = {
				automatic_installation = true,
				handlers = {}, -- Can be extended for custom debugger configurations
				ensure_installed = {
					"python", -- Example debuggers, update as needed
					"delve", -- Go debugger
					"codelldb", -- C/C++/Rust
				},
			},
		},
	},
	config = function()
		-- Buffer-local LSP mappings and UX
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				-- Rename
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				-- Code actions
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

				-- Reference highlights
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Inlay hints toggle (Neovim 0.11 API)
				if
					client
					and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
					and vim.lsp.inlay_hint
				then
					map("<leader>th", function()
						local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
						vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Capabilities (nvim-cmp)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Define server-specific configs to extend the defaults provided by nvim-lspconfig (lsp/*.lua)
		local servers = {
			-- Typescript
			ts_ls = {}, -- tsserver is deprecated -> use ts_ls

			-- Python (pylsp)
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = true },
							pycodestyle = { enabled = true },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = true },
							pylsp_mypy = { enabled = true },
							pylsp_black = { enabled = true },
							pylsp_isort = { enabled = true },
							rope_autoimport = {
								enabled = true,
								memory = true, -- use in-memory cache instead of writing to disk
								fuzzy = false, -- disable fuzzy matching to speed things up
								projectRoot = vim.fn.getcwd(), -- limit scope to the current working directory
								maxFiles = 1000, -- limit the number of files scanned
							},
						},
					},
				},
			},

			-- Web
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},

			-- Infra
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
		}

		-- Extend defaults for each server and include capabilities
		for name, cfg in pairs(servers) do
			vim.lsp.config(name, vim.tbl_deep_extend("force", { capabilities = capabilities }, cfg or {}))
		end

		-- Lua
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = { enable = false },
				},
			},
		})

		-- Clangd (let defaults handle root_dir and filetypes; just add capabilities/flags)
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			cmd = { "clangd", "--background-index" },
		})

		-- CMake
		vim.lsp.config("cmake", {
			capabilities = capabilities,
		})

		vim.lsp.config("tinymist", {
			single_file_support = true,
			settings = {
				exportPdf = "onSave",
			},
		})

		vim.lsp.config("racket_langserver", {})

		-- Mason core
		require("mason").setup()

		-- Ensure tools and LSP servers are installed
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"lua_ls",
			"clangd",
			"cmake",
			"stylua",
			"clangd", -- safe if duplicated
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- Optionally, ask mason-lspconfig to ensure servers are installed (new API doesn't require handlers)
		require("mason-lspconfig").setup({
			ensure_installed = ensure_installed,
		})

		-- Enable all configured servers so they attach for their filetypes
		for name, _ in pairs(servers) do
			pcall(vim.lsp.enable, name)
		end
		for _, name in ipairs({ "lua_ls", "clangd", "cmake", "racket_langserver" }) do
			pcall(vim.lsp.enable, name)
		end
	end,
}
