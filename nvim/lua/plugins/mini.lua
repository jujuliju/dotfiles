-- One copy of mini.nvim provides every mini module used here.
return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        require("mini.pairs").setup({
            modes = { insert = true, command = true, terminal = false },
        })

        local statusline = require("mini.statusline")
        statusline.setup({ use_icons = true })
        statusline.section_location = function()
            return "%2l:%-2v"
        end
    end,
}
