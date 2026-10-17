return {
    {
        "nvim-telescope/telescope.nvim",
        -- Not the stale 0.1.x branch: it breaks previews with current
        -- nvim-treesitter (attempt to call field 'ft_to_lang').
        branch = "master",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
}
