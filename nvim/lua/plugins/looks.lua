return {
    {
        "navarasu/onedark.nvim",
        priority = 1000, -- Load first
        opts = {
            style = "dark",
            transparent = true,
            code_style = { comments = "italic" },
        },
        init = function()
            require("onedark").load()
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },

    "tpope/vim-sleuth", -- Tab detection

    {
        "echasnovski/mini.statusline",
        config = function()
            local statusline = require("mini.statusline")
            statusline.setup({ use_icons = true })
            statusline.section_location = function()
                return "%2l:%-2v"
            end
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-mini/mini.nvim",
        },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
}
