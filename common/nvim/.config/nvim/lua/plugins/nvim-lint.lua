return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				python = { "ruff" },
				make = { "checkmake" },
				sh = { "shellcheck" },
			}

			-- Run linting on save
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					python = { "black", "ruff_format" },
					sh = { "shfmt" },
					go = { "goimports" },
					terraform = { "terraform_fmt" },
					c = { "clang_format" },
					cpp = { "clang_format" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
			})
		end,
	},
}
