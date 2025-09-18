-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.maplocalleader = " "
vim.g.snacks_animate = false -- disable smooth scrolling

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

vim.g.have_nerd_font = true
-- NOTE: comment if this causes issues
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

--TODO: move to ~/.config/nvim/after/ftplugin/go.lua
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = false

-- vim.o.shift
vim.filetype.add({
  extension = {
    http = "http",
  },
})

vim.o.background = "dark"
