return {
  "mistweaverco/kulala.nvim",
  opts = {
    debug = 3, -- 0..3, per docs

    scripts = {
      node_path_resolver = function()
        return vim.fn.exepath("node")
      end,
    },

    ui = {
      default_winbar_panes = { "body", "headers", "headers_body", "script_output" },
      -- optional, but helpful while debugging:
      disable_script_print_output = false,
      report = {
        show_script_output = true,
      },
    },

    global_keymaps = {
      ["Send request"] = {
        "<leader>rr",
        function() require("kulala").run() end,
        mode = { "n" },
      },
      ["Send all requests"] = {
        "<leader>Ra",
        function() require("kulala").run_all() end,
        mode = { "n", "v" },
        ft = "http",
      },
      ["Copy as cURL"] = {
        "<leader>co",
        function() require("kulala").copy() end,
        ft = { "http", "rest" },
      },
      ["Inspect current request"] = {
        "<leader>i",
        function() require("kulala").inspect() end,
        ft = { "http", "rest" },
      },
      ["Toggle headers/body"] = {
        "<leader>tv",
        function() require("kulala").toggle_view() end,
        ft = { "http", "rest" },
      },
      ["Find request"] = false,
    },
  },
}
