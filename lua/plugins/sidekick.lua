disable_projects = {
  "/home/saeruig/Development/leetcode",
  "/home/saeruig/Development/rust",
}
return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "github/copilot.vim"
    },
    init = function()
      local cwd = vim.fn.getcwd()
      for _, path in ipairs(disable_projects) do
        if cwd == path then
          return
        end
      end
      vim.lsp.enable("copilot")
    end
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      return vim.fn.getcwd() ~= "/home/saeruig/Development/leetcode"
    end
  },
  {
    "github/copilot.vim",
    enabled = function()
      return vim.fn.getcwd() ~= "/home/saeruig/Development/leetcode"
    end
  }
}
