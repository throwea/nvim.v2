-- ============================================================
-- Repos where Copilot ghost text is active.
-- Add the absolute path to any repo you want enabled here.
-- ============================================================
local allowed_repos = {
  "/Users/elianahmar/Development/nova",
  "/Users/elianahmar/Development/prof.ai",
  "/Users/elianahmar/.config/nvim",
}

local function is_allowed_repo()
  local cwd = vim.fn.getcwd()
  for _, path in ipairs(allowed_repos) do
    if cwd == path or cwd:find("^" .. vim.pesc(path) .. "/") then
      return true
    end
  end
  return false
end

return {
  {
    "github/copilot.vim",

    event = "VeryLazy",
    init = function()
      -- Don't let Copilot claim Tab (keeps normal indent behaviour)
      vim.g.copilot_no_tab_map = true
      -- Start globally disabled; the autocmd below enables it per repo
      vim.g.copilot_enabled = 0
      -- Copilot requires Node 22+; point it at the nvm-managed binary
      -- so it isn't affected by whatever `node` is on PATH (e.g. Homebrew node@20)
      vim.g.copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.13.1/bin/node")
    end,
    config = function()
      -- Accept the inline ghost-text suggestion.
      -- <F13> is a real key; map CapsLock → F13 via Karabiner-Elements
      -- (see Phase 4 of the implementation plan for setup steps).
      vim.keymap.set("i", "<Right>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
        desc = "Copilot: accept suggestion",
      })

      local function update_copilot()
        if is_allowed_repo() then
          vim.cmd("silent! Copilot enable")
        else
          vim.cmd("silent! Copilot disable")
        end
      end

      vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        callback = update_copilot,
      })
    end,
  },
}
