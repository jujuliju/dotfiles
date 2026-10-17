local map = vim.keymap.set

-- Wrap a telescope picker so telescope is only loaded when the key is used
local function telescope(picker, opts)
    return function()
        require("telescope.builtin")[picker](opts)
    end
end

-- Reset to center of screen on movement
map("n", "<C-d>", "<C-d>zz", { silent = true })
map("n", "<C-u>", "<C-u>zz", { silent = true })

-- Exit insert softly with Ctrl + c
map("i", "<C-c>", "<Esc>", { silent = true })

-- Close highlighting when searching
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map(
    "n",
    "<leader>e",
    vim.diagnostic.open_float,
    { desc = "Show diagnostic [E]rror messages" }
)

-- Telescope
map(
    "n",
    "<leader>sf",
    telescope("find_files"),
    { desc = "Telescope find files" }
)
map("n", "<leader>sg", telescope("live_grep"), { desc = "Telescope live grep" })
map(
    "n",
    "<leader>sn",
    telescope("find_files", { cwd = vim.fn.stdpath("config") }),
    { desc = "Telescope search config" }
)
map(
    "n",
    "<leader>sc",
    "<cmd>TodoTelescope<CR>",
    { desc = "Telescope search comments" }
)

-- Sudo write
vim.cmd.cnoreabbrev("w!! SudoWrite")

-- Trouble
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

-- COMPETITIVE PROGRAMMING
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

-- Formatting lives in plugins/lsp.lua (conform's `keys`): <leader>f
