vim.cmd([[
    highlight! yank-highlight guifg=#ffffff guibg=#EE82EE gui=bold
    highlight! gitblame guifg=#9f9f9f gui=bold
]])

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = "yank-highlight", timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

vim.api.nvim_create_user_command("T", function(opts)
    vim.cmd("terminal " .. opts.args)
end, { nargs = "*", complete = "file" })
