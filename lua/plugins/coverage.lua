return {
  "andythigpen/nvim-coverage",
  requires = "nvim-lua/plenary.nvim",
  -- Optional: needed for PHP when using the cobertura parser
  config = function()
    local builtin = require("coverage")
    builtin.setup()
    vim.keymap.set("n", "<leader>tc", function()
      -- builtin.load_lcov(vim.fn.getcwd() .. '/coverage.out', true)
      builtin.load(true)
    end, { desc = "Show [t]est [c]overage" })
  end,
  -- keys = {
  --   { vim.keymap.set('n', '<leader>tc', function() require('coverage').toggle() end, { desc = 'Show [t]est [c]overage' }) },
  -- },
}
