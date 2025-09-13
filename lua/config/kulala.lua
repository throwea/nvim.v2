return {
  "mistweaverco/kulala.nvim",
  opts = {
    debug = true,
    global_keymaps = {
      ["Send request"] = { -- sets global mapping
        "<leader>rr",
        function()
          require("kulala").run()
        end,
        mode = { "n" }, -- optional mode, default is n
        desc = "Send request", -- optional description, otherwise inferred from the key
      },
      ["Send all requests"] = {
        "<leader>Ra",
        function()
          require("kulala").run_all()
        end,
        mode = { "n", "v" },
        ft = "http", -- sets mapping for *.http files only
      },
      ["Copy as cURL"] = {
        "<leader>co",
        function()
          require("kulala").copy()
        end,
        ft = { "http", "rest" }, -- sets mapping for specified file types
      },
      ["Inspect current request"] = {
        "<leader>i",
        function()
          require("kulala").inspect()
        end,
        ft = { "http", "rest" },
      },
      ["Toggle headers/body"] = {
        "<leader>tv",
        function()
          require("kulala").toggle_view()
        end,
        ft = { "http", "rest" },
      },
      ["Find request"] = false, -- set to false to disable
    },
  },
}
