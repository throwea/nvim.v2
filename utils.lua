-- NOTE:
--  - In lua, they don't support private and public methods. However, you can simulate this by defining local functions at the top and object/table methods at the bottom.
--  - An even easier way is to forward declare the private methods at the top. That way you can reference the method before defining it

local utils = {} -- Defining an object to hold our functions
-- PRIVATE METHODS
-- NOTE: forward declaring these methods here so I can reference them before defining them
local save_args_history_python, load_args_history

-- Save debugger command args to history file
-- @param history: table of strings representing previous command line args
-- @param args history file: (string) path to history file
save_args_history_python = function(history, args_history_file)
  local f = io.open(args_history_file, "w")
  if not f then
    vim.notify("failed to open file for writing: " .. args_history_file, vim.log.level.ERROR)
    return
  end
  local commandMap = {}
  for _, line in pairs(history) do
    commandMap[line] = true
  end
  if commandMap then -- NOTE: similar syntax to python. if <obj> then do something will check for nil-ness
    for _, line in ipairs(history) do
      f:write(line .. "\n")
    end
    f:close()
  end
end

-- Get list of previously used command line args or prompt user for new args
-- @param args_history_file: (string) path to history file
function utils.get_args(args_history_file)
  local history = load_args_history(args_history_file)
  local choices = vim.deepcopy(history) -- TODO: why are we doing deepcopy here?
  table.insert(choices, "Enter new args") -- TODO why is this needed
  local choice = vim.fn.inputlist(choices)
  local args_string
  if choice > 0 and choice <= #history then
    args_string = history[choice]
  else
    args_string = vim.fn.input("Args: ")
    if args_string ~= "" and not vim.tbl_contains(history, args_string) then
      table.insert(history, 1, args_string)
      -- Keep only last 10 entries
      while #history > 10 do
        table.remove(history)
      end
      save_args_history_python(history)
    end
  end
  return vim.split(args_string, " ")
end

-- Read the previously used command line args from history
-- @param args_history_file: path to file containing previously used command line args
load_args_history = function(args_history_file)
  -- local args_history_file = vim.fn.stdpath("data") .. "/dap_python_args_history.txt" --NOTE: hardcoded for now... Can hardcode this in debug.lua
  local lines = {}
  local f = io.open(args_history_file, "r") -- f is of type (file*?) basically a pointer to a file (*) and can be nil (?)
  if not f then
    f = io.open(args_history_file, "w")
    -- If we fail again, then we need to notify and log
    if not f then
      vim.notify("Failed to create args file: " .. args_history_file, vim.log.levels.ERROR)
      return
    end
  end
  if f then
    for line in f:lines() do
      if line ~= "" then
        table.insert(lines, line)
      end
    end
    f:close()
  end
  return lines
end

--NOTE: Return the utils object which is a table containing our functions
return utils
