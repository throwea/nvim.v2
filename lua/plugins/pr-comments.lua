return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local previewers = require("telescope.previewers")

    -- Helper function to check if we're in a git repo
    local function is_git_repo()
      local git_dir = vim.fn.system("git rev-parse --git-dir 2>/dev/null")
      return vim.v.shell_error == 0
    end

    -- Helper function to get current PR number
    local function get_current_pr()
      if not is_git_repo() then
        return nil
      end
      
      -- Try to get PR number from current branch
      local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
      if branch == "" then
        return nil
      end
      
      -- Check if there's a PR for this branch
      local pr_output = vim.fn.system("gh pr view --json number 2>/dev/null")
      if vim.v.shell_error == 0 then
        local ok, pr_data = pcall(vim.json.decode, pr_output)
        if ok and pr_data.number then
          return tostring(pr_data.number)
        end
      end
      
      return nil
    end

    -- Parse PR comments from gh output
    local function parse_pr_comments(pr_number)
      if not pr_number then
        return {}
      end

      local cmd = string.format("gh pr view %s --json comments --jq '.comments[]'", pr_number)
      local output = vim.fn.system(cmd)
      
      if vim.v.shell_error ~= 0 then
        vim.notify("Failed to fetch PR comments: " .. output, vim.log.levels.ERROR)
        return {}
      end

      local comments = {}
      local lines = vim.split(output, "\n", { trimempty = true })
      
      for _, line in ipairs(lines) do
        if line ~= "" then
          local ok, comment_data = pcall(vim.json.decode, line)
          if ok and comment_data then
            local author = comment_data.author and comment_data.author.login or "Unknown"
            local body = comment_data.body or ""
            local created_at = comment_data.createdAt or ""
            local url = comment_data.url or ""
            
            -- Format the timestamp
            local formatted_date = created_at:gsub("T", " "):gsub("Z", ""):sub(1, 19)
            
            table.insert(comments, {
              author = author,
              body = body,
              created_at = formatted_date,
              url = url,
              display = string.format("[%s] %s: %s", formatted_date, author, body:sub(1, 100) .. (body:len() > 100 and "..." or ""))
            })
          end
        end
      end
      
      return comments
    end

    -- Custom previewer for PR comments
    local function comment_previewer()
      return previewers.new_buffer_previewer({
        title = "PR Comment Details",
        define_preview = function(self, entry, status)
          local comment = entry.value
          local lines = {
            "Author: " .. comment.author,
            "Date: " .. comment.created_at,
            "URL: " .. comment.url,
            "",
            "Comment:",
            "--------"
          }
          
          -- Split comment body into lines and add them
          local body_lines = vim.split(comment.body, "\n", { trimempty = false })
          for _, line in ipairs(body_lines) do
            table.insert(lines, line)
          end
          
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          
          -- Set markdown filetype for better syntax highlighting
          vim.bo[self.state.bufnr].filetype = "markdown"
        end,
      })
    end

    -- Main PR comments picker
    local function pr_comments_picker(opts)
      opts = opts or {}
      
      if not is_git_repo() then
        vim.notify("Not in a git repository", vim.log.levels.WARN)
        return
      end

      -- Check if gh CLI is available
      local gh_available = vim.fn.executable("gh") == 1
      if not gh_available then
        vim.notify("GitHub CLI (gh) is not installed or not in PATH", vim.log.levels.ERROR)
        return
      end

      local pr_number = get_current_pr()
      if not pr_number then
        vim.notify("No PR found for current branch. You can specify PR number manually.", vim.log.levels.WARN)
        -- Prompt user for PR number
        vim.ui.input({ prompt = "Enter PR number (or press ESC to cancel): " }, function(input)
          if input and input ~= "" then
            pr_number = input
            show_pr_comments(pr_number, opts)
          end
        end)
        return
      end
      
      show_pr_comments(pr_number, opts)
    end

    function show_pr_comments(pr_number, opts)
      local comments = parse_pr_comments(pr_number)
      
      if #comments == 0 then
        vim.notify("No comments found for PR #" .. pr_number, vim.log.levels.INFO)
        return
      end

      pickers.new(opts, {
        prompt_title = "PR #" .. pr_number .. " Comments (" .. #comments .. " total)",
        finder = finders.new_table({
          results = comments,
          entry_maker = function(comment)
            return {
              value = comment,
              display = comment.display,
              ordinal = comment.author .. " " .. comment.body .. " " .. comment.created_at,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        previewer = comment_previewer(),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            
            if selection and selection.value.url then
              -- Copy URL to clipboard
              vim.fn.setreg("+", selection.value.url)
              vim.notify("Comment URL copied to clipboard", vim.log.levels.INFO)
            end
          end)
          
          -- Add custom mapping to open URL in browser
          map("i", "<C-o>", function()
            local selection = action_state.get_selected_entry()
            if selection and selection.value.url then
              local url = selection.value.url
              -- Try different commands based on the system
              local open_cmd = "xdg-open"  -- Linux
              if vim.fn.has("mac") == 1 then
                open_cmd = "open"  -- macOS
              elseif vim.fn.has("win32") == 1 then
                open_cmd = "start"  -- Windows
              end
              
              vim.fn.system(open_cmd .. " " .. url)
              vim.notify("Opened comment in browser", vim.log.levels.INFO)
            end
          end)
          
          return true
        end,
      }):find()
    end

    -- Register the extension
    telescope.register_extension({
      exports = {
        pr_comments = pr_comments_picker
      }
    })
  end,
}