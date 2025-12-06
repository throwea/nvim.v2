return {
  {
    "folke/sidekick.nvim",
    dependencies = {
      "github/copilot.vim"
    },
    init = function()
      local cwd = vim.fn.getcwd()
      if cwd ~= "/Users/elianahmar/Development/leetcode" then
        vim.lsp.enable("copilot")
      end
    end
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      return vim.fn.getcwd() ~= "/Users/elianahmar/Development/leetcode"
    end
  },
  {
    "github/copilot.vim",
    enabled = function()
      return vim.fn.getcwd() ~= "/Users/elianahmar/Development/leetcode"
    end
  }
}
