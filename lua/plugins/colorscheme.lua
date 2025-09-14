return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      -- overrides = {
      --   ["@lsp.type.function"] = { bg = "#ff9900", bold = true },
      --   ["@comment.lua"] = { bg = "#000000", bold = false, italic = false },
      -- },
    },
  },

  -- Configure LazyVim to load gruvbox...
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
