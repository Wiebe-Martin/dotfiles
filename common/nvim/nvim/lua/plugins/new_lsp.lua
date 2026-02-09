return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        { "j-hui/fidget.nvim", opts = {} },

        "saghen/blink.cmp",

        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = true,
                handlers = {},
                ensure_installed = {
                    "lua_ls",
                    "python",
                    "codelldb",
                },
            },
        },
    },
    config = function()
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

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method("textDocument/documentHighlight", event.buf) then
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

                -- Inlay hints toggle
                if client and client:supports_method("textDocument/inlayHint", event.buf) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local servers = {
            -- LSPs
            "clangd",
            -- "cmake-language-server",
            "python-lsp-server",
            "lua-language-server",
            "tinymist",

            -- Linters
            "flake8",

            -- Formatters
            "stylua",
            "black",
            "ruff",
            "clang-format",

            -- DAPs
            "debugpy",
        }

        require("mason-tool-installer").setup({ ensure_installed = servers })

        -- Special Lua Config, as recommended by neovim help docs
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            on_init = function(client)
                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                        path ~= vim.fn.stdpath("config")
                        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                    then
                        return
                    end
                end

                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                        path = { "lua/?.lua", "lua/?/init.lua" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                        --  See https://github.com/neovim/nvim-lspconfig/issues/3189
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                })
            end,
            settings = {
                Lua = {},
            },
        })

        -- Python (pylsp)
        vim.lsp.config("pylsp", {
            capabilities = capabilities,
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
        })

        -- C
        vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = { "clangd", "--background-index" },
        })

        -- Typst
        vim.lsp.config("tinymist", {
            capabilities = capabilities,
            single_file_support = true,
            settings = {
                exportPdf = "onSave",
            },
        })

        -- Racket
        vim.lsp.config("racket_langserver", {
            capabilities = capabilities,
        })

        vim.lsp.enable({
            "lua_ls",
            "racket_langserver",
            "tinymist",
            "racket_langserver",
            "clangd",
            -- "cmake",
            "pylsp",
        })
    end,
}
