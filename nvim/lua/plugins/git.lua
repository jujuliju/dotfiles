return {
    {
        "akinsho/git-conflict.nvim",
    },

    {
        "sindrets/diffview.nvim",
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
