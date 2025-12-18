-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable Copilot/Sidekick in specific directories
local disable_projects = {
  "/Users/elianahmar/Development/leetcode",
  "/Users/elianahmar/Development/rust",
}

local function is_disabled_project()
  local cwd = vim.fn.getcwd()
  for _, path in ipairs(disable_projects) do
    if cwd == path or cwd:find("^" .. path .. "/") then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  callback = function()
    if is_disabled_project() then
      vim.g.sidekick_suggestion_auto_trigger = false
      vim.g.sidekick_suggestion_enabled = false
      vim.cmd("silent! Copilot disable")
      
      -- Disable Sidekick keymaps
      pcall(vim.keymap.del, "i", "<Tab>")
      pcall(vim.keymap.del, "i", "<S-Tab>")
    else
      vim.g.sidekick_suggestion_auto_trigger = true
      vim.g.sidekick_suggestion_enabled = true
      vim.cmd("silent! Copilot enable")
    end
  end,
})
