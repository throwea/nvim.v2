return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    -- Uncomment to enable LSP in files with specific build tags (e.g. //go:build integration)
    -- servers = {
    --   gopls = {
    --     settings = {
    --       gopls = {
    --         buildFlags = { "-tags=integration" },
    --       },
    --     },
    --   },
    -- },
  },
}
