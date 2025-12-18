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

return {
  {
    "folke/sidekick.nvim",
    optional = true,
    opts = {
      suggestion = {
        auto_trigger = not is_disabled_project(),
        enabled = not is_disabled_project(),
      },
    },
  },
}
