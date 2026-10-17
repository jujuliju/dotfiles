-- Formatters and other tools Mason should install (Mason package names).
-- LSP servers are not listed here, they live in the `servers` table below.
local mason_tools = { "stylua", "clang-format" }

return {
    { -- LSP
        "neovim/nvim-lspconfig",
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },

        config = function()
            vim.lsp.config("*", {
                root_markers = { ".git" },
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Use Espressif's clangd inside an ESP-IDF shell, plain clangd
            -- everywhere else.
            local function detect_clangd_path()
                local idf_path = vim.env.IDF_PATH
                if idf_path and idf_path ~= "" then
                    local found = vim.fn.glob(
                        vim.env.HOME
                            .. "/.espressif/tools/esp-clang/*/esp-clang/bin/clangd",
                        false,
                        true
                    )
                    if #found > 0 then
                        table.sort(found)
                        return found[#found] -- newest version
                    end
                end
                return "clangd"
            end

            -- Servers installed through Mason. The key is the lspconfig name,
            -- `{}` means default settings.
            local servers = {
                -- C, C++
                clangd = {
                    cmd = {
                        detect_clangd_path(),
                        "--background-index",
                        "-j=12",
                        "--query-driver=**",
                        "--clang-tidy",
                        "--all-scopes-completion",
                        "--cross-file-rename",
                        "--completion-style=detailed",
                        "--header-insertion-decorators",
                        "--header-insertion=iwyu",
                        "--pch-storage=memory",
                    },

                    root_markers = {
                        "compile_commands.json",
                        ".clangd",
                        ".git",
                    },
                },
                -- Python
                pyright = {},
                -- Lua
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }, -- Set vim as a keyword recognized
                            },
                        },
                    },
                },
                -- Julia (needs `julia` on PATH; the first start is slow while
                -- LanguageServer.jl precompiles)
                julials = {},
            }

            -- Servers that must come from outside Mason because they have to
            -- match the project's toolchain. Install them yourself:
            --   opam install ocaml-lsp-server ocamlformat
            local external = {
                -- OCaml
                ocamllsp = {},
            }

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup(
                    "lsp-attach",
                    { clear = true }
                ),
                callback = function(ev)
                    local map = function(k, f, d)
                        vim.keymap.set("n", k, f, { buffer = ev.buf, desc = d })
                    end
                    local function telescope(picker)
                        return function()
                            require("telescope.builtin")[picker]()
                        end
                    end

                    map(
                        "gd",
                        telescope("lsp_definitions"),
                        "[G]oto [D]efinition"
                    )
                    map(
                        "gI",
                        telescope("lsp_implementations"),
                        "[G]oto [I]mplementation"
                    )
                    map(
                        "gr",
                        telescope("lsp_references"),
                        "[G]oto [R]eferences"
                    )
                    map(
                        "<leader>ds",
                        telescope("lsp_document_symbols"),
                        "[D]ocument [S]ymbols"
                    )
                    map(
                        "<leader>ws",
                        telescope("lsp_dynamic_workspace_symbols"),
                        "[W]orkspace [S]ymbols"
                    )
                    map(
                        "<leader>D",
                        telescope("lsp_type_definitions"),
                        "Type [D]efinition"
                    )
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("K", vim.lsp.buf.hover, "Hover")
                    map(
                        "<leader>ca",
                        vim.lsp.buf.code_action,
                        "[C]ode [A]ction"
                    )

                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Highlight the symbol under the cursor. One augroup per
                    -- buffer, otherwise attaching a second buffer would clear
                    -- the autocmds of the first.
                    if
                        client
                        and client.server_capabilities.documentHighlightProvider
                    then
                        local grp = vim.api.nvim_create_augroup(
                            "lsp-highlight-" .. ev.buf,
                            { clear = true }
                        )
                        vim.api.nvim_create_autocmd(
                            { "CursorHold", "CursorHoldI" },
                            {
                                buffer = ev.buf,
                                group = grp,
                                callback = vim.lsp.buf.document_highlight,
                            }
                        )
                        vim.api.nvim_create_autocmd(
                            { "CursorMoved", "CursorMovedI" },
                            {
                                buffer = ev.buf,
                                group = grp,
                                callback = vim.lsp.buf.clear_references,
                            }
                        )
                    end

                    if
                        client and client.server_capabilities.inlayHintProvider
                    then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(
                                not vim.lsp.inlay_hint.is_enabled({
                                    bufnr = ev.buf,
                                }),
                                { bufnr = ev.buf }
                            )
                        end, "[T]oggle Inlay [H]ints")
                    end
                end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup(
                    "lsp-detach",
                    { clear = true }
                ),
                callback = function(ev)
                    vim.lsp.buf.clear_references()
                    pcall(
                        vim.api.nvim_del_augroup_by_name,
                        "lsp-highlight-" .. ev.buf
                    )
                end,
            })

            for name, cfg in pairs(servers) do
                vim.lsp.config(name, cfg)
            end

            -- mason-lspconfig only enables servers it installed, so servers
            -- from outside Mason are enabled by hand.
            for name, cfg in pairs(external) do
                vim.lsp.config(name, cfg)
                vim.lsp.enable(name)
            end

            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_enable = true,
            })
        end,
    },

    { -- LSP progress in the corner
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },

    { -- Nicer vim.ui.select / vim.ui.input (optional, Neovim has built-ins)
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    { -- Installs the formatters listed at the top of this file
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { { "mason-org/mason.nvim", opts = {} } },
        opts = { ensure_installed = mason_tools },
    },

    { -- Formatters
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ lsp_format = "fallback" })
                end,
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            -- Filetypes without an entry use the LSP server's formatting
            -- (lsp_format = "fallback"), which is what Julia and Python get.
            formatters_by_ft = {
                lua = { "stylua" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                -- Installed with opam, not Mason. The conform definition passes
                -- --enable-outside-detected-project, so no .ocamlformat needed.
                ocaml = { "ocamlformat" },
            },

            formatters = {
                stylua = {
                    prepend_args = {
                        "--indent-width",
                        "4",
                        "--indent-type",
                        "Spaces",
                        "--column-width",
                        "80",
                    },
                },
                clang_format = {
                    -- A project's own .clang-format wins. Without one, use
                    -- this style.
                    prepend_args = function(_, ctx)
                        local project_style = vim.fs.find(
                            { ".clang-format", "_clang-format" },
                            { upward = true, path = ctx.dirname }
                        )[1]
                        if project_style then
                            return {}
                        end
                        return {
                            "--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 80, AlignConsecutiveAssignments: AcrossEmptyLines, AlignConsecutiveMacros: AcrossEmptyLines}",
                        }
                    end,
                },
            },

            -- The first Julia format is slow (JuliaFormatter precompiles)
            format_on_save = function(bufnr)
                local slow = { julia = 5000 }
                return {
                    lsp_format = "fallback",
                    timeout_ms = slow[vim.bo[bufnr].filetype] or 1000,
                }
            end,
        },
    },

    { -- Completion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            {
                "L3MON4D3/LuaSnip",
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
            },
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                completion = { completeopt = "menu,menuone,noinsert" },

                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Tab>"] = cmp.mapping.select_next_item(),
                    ["<C-S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        opts = {},
    },
}
