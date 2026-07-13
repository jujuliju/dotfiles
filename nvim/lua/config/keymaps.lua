local map = vim.keymap.set

-- Reset to center of screen on movement
map("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

map("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- Exit insert softly with Ctrl + c
map("i", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Close highlighting when searching
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    { desc = "Show diagnostic [E]rror messages" }
)

local builtin = require("telescope.builtin")
map("n", "<leader>sf", builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>sg", builtin.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Telescope search config" })
map(
    "n",
    "<leader>sc",
    "<cmd>TodoTelescope<CR>",
    { desc = "Telescope search comments" }
)

map("n", "<leader>f", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "Format with Conform" })

-- Sudo write
vim.cmd.cnoreabbrev("w!! SudoWrite")

map(
    "n",
    "<leader>xx",
    "<cmd>Trouble diagnostics toggle<cr>",
    { desc = "Diagnostics (workspace)" }
)
map(
    "n",
    "<leader>xX",
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { desc = "Diagnostics (buffer)" }
)
map(
    "n",
    "<leader>cs",
    "<cmd>Trouble symbols toggle focus=false<cr>",
    { desc = "Symbols" }
)
map(
    "n",
    "<leader>cl",
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { desc = "LSP (defs/refs/…)" }
)
map(
    "n",
    "<leader>xL",
    "<cmd>Trouble loclist toggle<cr>",
    { desc = "Location List" }
)
map(
    "n",
    "<leader>xQ",
    "<cmd>Trouble qflist toggle<cr>",
    { desc = "Quickfix List" }
)

-- COMPETETIVE PROGRAMMING
map("n", "<leader>cp", function()
    local template = [[#include <bits/stdc++.h>
using namespace std;

#define fastio ios::sync_with_stdio(false); cin.tie(nullptr)
int main() {
    fastio;
}
]]
    vim.api.nvim_put(vim.split(template, "\n"), "l", true, true)
end, { desc = "Paste C++ CP template" })
