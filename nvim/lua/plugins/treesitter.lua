return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    init = function()
        -- Needs the `tree-sitter` CLI and a C compiler to build parsers.
        local ensure_installed = {
            -- Languages with an LSP server in plugins/lsp.lua
            "c",
            "cpp",
            "python",
            "lua",
            "luadoc",
            "julia",
            "ocaml",
            "ocaml_interface",

            -- Config and markup
            "bash",
            "json",
            "markdown",
            "markdown_inline",
            "vim",
            "vimdoc",
            "query",

            -- Web and Go (not used by any LSP yet)
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",
            "svelte",
            "jsdoc",
            "go",
        }

        local installed = require("nvim-treesitter.config").get_installed()
        local missing = vim.iter(ensure_installed)
            :filter(function(p)
                return not vim.tbl_contains(installed, p)
            end)
            :totable()
        if #missing > 0 then
            require("nvim-treesitter").install(missing)
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                -- Only use treesitter indenting where a parser actually started
                if pcall(vim.treesitter.start, ev.buf) then
                    vim.bo[ev.buf].indentexpr =
                        "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
