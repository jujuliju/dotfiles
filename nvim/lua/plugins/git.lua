return {
    { -- Needs setup() to do anything, `config = true` calls it
        "akinsho/git-conflict.nvim",
        config = true,
    },

    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewToggleFiles",
            "DiffviewFocusFiles",
            "DiffviewRefresh",
            "DiffviewFileHistory",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },

    {
        "f-person/git-blame.nvim",
        opts = {
            virtual_text_column = 80,
            date_format = "%r * %x",
            max_commit_summary_length = 50,
            highlight_group = "gitblame",
        },
    },
}
