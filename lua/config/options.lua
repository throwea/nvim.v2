-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.maplocalleader = " "

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- NOTE: comment if this causes issues
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.filetype.add({
  extension = {
    http = "http",
  },
})

vim.o.background = "dark"
