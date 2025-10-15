return {
  "nvim-telekasten/telekasten.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require('telekasten').setup({
      home = vim.fn.expand("~/notes"), -- Main notes directory
      take_over_my_home = true,
      auto_set_filetype = true,
      dailies = vim.fn.expand("~/notes/daily"),
      weeklies = vim.fn.expand("~/notes/weekly"),
      templates = vim.fn.expand("~/notes/templates"),
      template_new_note = vim.fn.expand("~/notes/templates/new_note.md"),
      template_new_daily = vim.fn.expand("~/notes/templates/daily.md"),
      template_new_weekly = vim.fn.expand("~/notes/templates/weekly.md"),
      plug_into_calendar = false,
      close_after_yank = false,
      insert_after_inserting = true,
      follow_creates_nonexisting = true,
      tag_notation = "#tag",
      command_palette_theme = "dropdown",
      show_tags_theme = "dropdown",
    })
  end,
}
