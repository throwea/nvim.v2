-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.lsp.start({
      name = "oneclicklsp",
      cmd = { "/Users/e0a09hp/Development/one-click-suite/ocs-lsp-server/main" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]) or vim.loop.cwd(),
    })
  end,
})
