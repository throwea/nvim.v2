local disable_projects = {
  "/Users/elianahmar/Development/leetcode",
  "/Users/elianahmar/Development/rust",
}

local function is_disabled_project()
  local cwd = vim.fn.getcwd()
  for _, path in ipairs(disable_projects) do
    if cwd == path or cwd:find("^" .. vim.pesc(path) .. "/") then
      return true
    end
  end
  return false
end

return {
  {
    "folke/sidekick.nvim",
    optional = true,
    opts = function()
      return {
        suggestion = {
          auto_trigger = not is_disabled_project(),
          enabled = not is_disabled_project(),
        },
      }
    end,
    config = function(_, opts)
      require("sidekick").setup(opts)
      
      -- Dynamically toggle suggestions when changing directories
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          local should_disable = is_disabled_project()
          require("sidekick.suggestion").toggle(not should_disable)
        end,
      })
    end,
  },
}
