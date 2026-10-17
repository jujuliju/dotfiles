-- Custom highlight groups. Re-applied on every colorscheme change, because a
-- colorscheme clears all highlights when it loads.
local function set_highlights()
    vim.api.nvim_set_hl(
        0,
        "yank-highlight",
        { fg = "#ffffff", bg = "#EE82EE", bold = true }
    )
    vim.api.nvim_set_hl(0, "gitblame", { fg = "#9f9f9f", bold = true })
end

set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Re-apply custom highlight groups",
    group = vim.api.nvim_create_augroup("custom-highlights", { clear = true }),
    callback = set_highlights,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({ higroup = "yank-highlight", timeout = 200 })
    end,
})

-- :T <cmd> runs a command in a terminal buffer
vim.api.nvim_create_user_command("T", function(opts)
    vim.cmd("terminal " .. opts.args)
end, { nargs = "*", complete = "file" })
