return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>fm",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end
        end,
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
            -- terraform = { "terraform_fmt" },
            c = { "clang_format" },
            cpp = { "clang_format" },
        },
        formatters = {
            stylua = {
                append_args = {
                    "--indent-type",
                    "Spaces",
                    "--indent-width",
                    "4",
                },
            },
            shfmt = {
                append_args = { "-i", "4" },
            },
            ruff = {
                append_args = { "--extend-select", "I", "--ignore", "F401" },
            },
        },
    },
}
