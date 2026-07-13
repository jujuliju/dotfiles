-- return {
--     "nvim-treesitter/nvim-treesitter",
--     branch = "main",
--     build = ":TSUpdate",
--     config = function()
--         local configs = require("nvim-treesitter.configs")
--
--         configs.setup({
--             ensure_installed = {
--                 "bash",
--                 "lua",
--                 "luadoc",
--                 "html",
--                 "css",
--                 "javascript",
--                 "tsx",
--                 "svelte",
--                 "jsdoc",
--                 "json",
--                 "markdown",
--                 "markdown_inline",
--             },
--             auto_install = true,
--             highlight = { enable = true },
--             indent = { enable = true },
--         })
--     end,
-- }

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    init = function()
        local ensure_installed = {
            "bash",
            "lua",
            "luadoc",
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",
            "svelte",
            "jsdoc",
            "json",
            "markdown",
            "markdown_inline",
            "vim",
            "vimdoc",
            "query",
            "go",
            "c",
            "cpp",
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
            callback = function()
                pcall(vim.treesitter.start)
                vim.bo.indentexpr =
                    "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
