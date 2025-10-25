-- NOTE:
--  - In lua, they don't support private and public methods. However, you can simulate this by defining local functions at the top and object/table methods at the bottom.
--  - An even easier way is to forward declare the private methods at the top. That way you can reference the method before defining it
--  - On imports: in lua you define "modules" (file) inside a package (directory). If you want to import a file from the module you use require("package.module_name")
--      - In neovim, the convention is to put your lua modules in ~/.config/nvim/lua/ so that init.lua and other config files are seperate from from Lua Modules
--      - Modules in lua are similar to python packages. In this case, we have a lua mod

local utils = {} -- Defining an object to hold our functions
-- PRIVATE METHODS
-- NOTE: forward declaring these methods here so I can reference them before defining them
local save_args_history_python, load_args_history_python

-- Get list of previously used command line args or prompt user for new args
-- @param args_history_file: (string) path to history file
function utils.get_python_args(args_history_file)
  local history = load_args_history_python(args_history_file)
  local choices = vim.list_extend({ "Enter new args" }, history)
  local choice = vim.fn.inputlist(choices)
  
  local args_string
  if choice > 1 and choice <= #choices then
    args_string = history[choice - 1]
  else
    args_string = vim.fn.input("Args: ")
    if args_string ~= "" and not vim.tbl_contains(history, args_string) then
      table.insert(history, 1, args_string)
      history = vim.list_slice(history, 1, 10)
      save_args_history_python(history, args_history_file)
    end
  end
  return vim.split(args_string, " ")
end

-- Read the previously used command line args from history
-- @param args_history_file: path to file containing previously used command line args
load_args_history_python = function(args_history_file)
  local f = io.open(args_history_file, "r")
  if not f then
    f = io.open(args_history_file, "w")
    if not f then
      vim.notify("Failed to create args file: " .. args_history_file, vim.log.levels.ERROR)
      return {}
    end
    f:close()
    return {}
  end
  
  local lines = {}
  for line in f:lines() do
    if line ~= "" then
      table.insert(lines, line)
    end
  end
  f:close()
  return lines
end

-- Save debugger command args to history file
-- @param history: table of strings representing previous command line args
-- @param args history file: (string) path to history file
save_args_history_python = function(history, args_history_file)
  local f = io.open(args_history_file, "w")
  if not f then
    vim.notify("failed to open file for writing: " .. args_history_file, vim.log.levels.ERROR)
    return
  end
  
  for _, line in ipairs(history) do
    f:write(line .. "\n")
  end
  f:close()
end

-- TODO: get the current workspace path and try to retreive the venv/bin/python and concatenate
function get_python_venv()
  return ""
end

--NOTE: Return the utils object which is a table containing our functions
return utils
