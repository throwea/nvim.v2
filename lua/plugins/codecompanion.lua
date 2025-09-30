-- NOTE: Copilot only works on dev proxy
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    -- -- NOTE: The log_level is in `opts.opts`
    -- opts = {
    --   log_level = "DEBUG",
    --   http_proxy = vim.env.HTTP_PROXY,
    --   https_proxy = vim.env.HTTPS_PROXY,
    -- },
  },
}

-- NOTE: usage
-- /buffer -> use tab to include multiple buffers
-- in chat window use gx to clear the conversation
-- @{insert_edit_into_file} to have copilot make changes
