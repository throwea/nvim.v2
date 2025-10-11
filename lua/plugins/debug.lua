-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)
-- local utils = require("utils")

return {
  -- NOTE: Yes, you can install new plugins here!
  "mfussenegger/nvim-dap",
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Installs the debug adapters for you
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",

    -- Add your own debuggers here
    "leoluz/nvim-dap-go",
    "mfussenegger/nvim-dap-python",
  },
  keys = function(_, keys)
    local dap = require("dap")
    local dapui = require("dapui")
    local snacks = require("snacks")
    return {
      -- Basic debugging keymaps, feel free to change to your liking!
      { "<F5>", dap.continue,  desc = "Debug: Start/Continue" },
      { "<F1>", dap.step_into, desc = "Debug: Step Into" },
      { "<F2>", dap.step_over, desc = "Debug: Step Over" },
      { "<F3>", dap.step_out,  desc = "Debug: Step Out" },
      { "<F4>", dap.close,     desc = "Debug: Stop Process" },
      {
        "<F6>",
        function()
          -- Get breakpoints from DAP
          local breakpoints = dap.list_breakpoints()
          if breakpoints == nil then
            snacks.notify.warn("No breakpoints set")
          end
          snacks.notify.warn("Here are the list of breakpoints" .. breakpoints)

          -- Transform breakpoints into picker items
          local items = {}
          for buf, buf_bps in pairs(breakpoints) do
            snacks.notify.warn(vim.inspect("Buffer: " .. tostring(buf) .. ", buf_bps: " .. tostring(buf_bps)))
            local bufname = vim.api.nvim_buf_get_name(buf)
            for _, bp in ipairs(buf_bps) do
              table.insert(items, {
                text = string.format("%s:%d", bufname, bp.line),
                file = bufname,
                lnum = bp.line,
                col = 1,
              })
            end
          end

          -- Open picker with breakpoint items
          snacks.picker({
            items = items,
            format = "file",  -- Use file formatter preset
            preview = "file", -- Use file previewer preset
            title = "Breakpoints",
            confirm = function(picker, item)
              if item then
                vim.cmd(string.format("edit +%d %s", item.lnum, item.file))
              end
            end,
          })
        end,
        desc = "Debug: List Breakpoints"
      },
      { "<F8>",      dap.restart_frame,     desc = "Debug: Stop Process" },
      { "<leader>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
      {
        "<leader>B",
        function()
          dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Set Breakpoint",
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      { "<F7>", dapui.toggle, desc = "Debug: See last session result." },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "delve",
        "gopls",
        "debugpy",
      },
    })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      floating = {
        border = "double",
      },
      controls = {
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
    })

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
    local breakpoint_icons = vim.g.have_nerd_font and {
      Breakpoint = "",
      BreakpointCondition = "",
      BreakpointRejected = "",
      LogPoint = "",
      Stopped = "",
    } or {
      Breakpoint = "●",
      BreakpointCondition = "⊜",
      BreakpointRejected = "⊘",
      LogPoint = "◆",
      Stopped = "⭔",
    }
    for type, icon in pairs(breakpoint_icons) do
      local tp = "Dap" .. type
      local hl = (type == "Stopped") and "DapStop" or "DapBreak"
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Installing python specific config
    -- TODO: When I run the launch file I need python from the virtual environment to be run
    require("dap-python").setup()
    table.insert(require("dap").configurations.python, {
      name = "Python Debugger: FastAPI (Affix)",
      type = "debugpy",
      request = "launch",
      module = "app.main",
      jinja = true,
      cwd = "${workspaceFolder}",
    })
    --NOTE: Don't forget to activate your venv and this will work just fine
    table.insert(require("dap").configurations.python, {
      name = "Python Debugger: Current File",
      type = "debugpy",
      request = "launch",
      module = "${file}",
      cwd = "${workspaceFolder}",
    })
    table.insert(require("dap").configurations.python, {
      name = "Python Debugger: Current File (Args, History)",
      type = "debugpy",
      request = "launch",
      -- TODO: make a util here for getting the environment python path
      python = "${workspaceFolder}/venv/bin/python", -- NOTE: when running debugger, launch nvim from same directory as venv
      program = "${file}",
      args = { "test" },
      cwd = "${workspaceFolder}",
    })
    -- Install golang specific config
    require("dap-go").setup({
      dap_configurations = {
        {
          type = "go",
          name = "Debug Providers",
          request = "launch",
          program = "${file}/cmd/main.go",
          args = require("dap-go").get_arguments,
          buildFlags = require("dap-go").get_build_flags,
        },
      },
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has("win32") == 0,
        build_flags = {
          check_current_version = false,
        },
      },
    })
  end,
}
