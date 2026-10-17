return {
    { -- Shows pending keybinds
        "folke/which-key.nvim",
        event = "VimEnter",
        opts = {
            spec = {
                { "<leader>s", group = "[S]earch" },
                { "<leader>c", group = "[C]ode" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>t", group = "[T]oggle" },
            },
        },
    },
}
