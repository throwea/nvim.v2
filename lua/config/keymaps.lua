-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("i", "kj", "<Esc>")
map("n", "<leader>d", "dd")

--Remap to drag text in visual mode -> Primeagen Keymaps
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Snacks Profiler. Comment if you ever need this
vim.keymap.del("n", "<Space>dpp")
vim.keymap.del("n", "<Space>dps")
vim.keymap.del("n", "<Space>dph")
vim.keymap.del("n", "<leader>l")
vim.keymap.del("n", "<leader>E")
vim.keymap.del("n", "<leader>e")
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "<leader>qu", vim.cmd.Ex, { desc = "Write and Exit to Explorer" })
map("n", "\\", Snacks.explorer.reveal, { desc = "Write and Exit to Explorer" })

-- MISCELLANEOUS KEYBINDINGS
map("n", "<leader>gmp", function()
  local packages = require("mason-registry").get_installed_package_names()
  local all_packages = table.concat(packages, "\n")
  vim.fn.setreg("+", all_packages)
  print("Copied Mason packages to clipboard")
end, { desc = "[G]et all [M]ason [P]ackages" })

map("n", "<leader>post", function()
  local request = {
    "###",
    "POST http://localhost:8080",
    "accept: application/json",
    "content-type: application/json",
    "authorization: bearer <token>",
    "\n{",
    '\t"param1": "test1"',
    "}",
  }
  -- vim.fn.setreg('+', request)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.fn.append(r, request)
end)

map("n", "<leader>get", function()
  --local request = '###\nGET http://localhost:8080/{endpoint}'
  local request = { "###", "GET http://localhost:8080/{endpoint}" }
  --vim.fn.setreg('+', request)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.fn.append(r, request)
end)

map("n", "<leader>err", function()
  --local request = '###\nGET http://localhost:8080/{endpoint}'
  local request = { "if err != nil {", "\treturn err", "}" }
  --vim.fn.setreg('+', request)
  local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.fn.append(r, request)
end)

-- TODO: figure out new bindings for these
-- <leader>e was pointing to snacks explorer which opens the file tree
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uick fix list' })
-- vim.keymap.set('n', '<leader>qu', vim.cmd.Ex, { desc = 'Write and Exit to Explorer' })
--

-- Quick fix remaps
--vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>")
--vim.keymap.set("n", "<M-k>", "<cmd>cprev<cr>")
--vim.keymap.set("n", "<M-e>", "<cmd>cexpr [] | cclose<cr>")
--vim.keymap.set("n", "<M-c>", "<cmd>cclose<cr>")

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>:q<CR>", { desc = "Exit terminal mode" })
map("n", "<leader>lg", function()
  Snacks.lazygit.open()
end)
map("n", "<leader>p", function()
  Snacks.picker.git_files()
end, { desc = "Open Git files" })

map("n", "\\", function()
  Snacks.explorer()
end, { desc = "Open Explorer" })
