-- ===========================================================================
-- copy_buffers.lua
-- ===========================================================================
-- Place this in your user config folder (e.g., ~/.config/nvim/lua/user/copy_buffers.lua)
-- and require it in your LazyVim or init.lua. Then use :CopyBuffers or <leader>cb.
-- ===========================================================================

-- Optional helper to guess a code fence language from file extension:
local function guess_language(file_name)
  file_name = file_name:lower()
  if file_name:match("%.tsx$") then
    return "```tsx"
  elseif file_name:match("%.ts$") then
    return "```ts"
  elseif file_name:match("%.js$") then
    return "```js"
  elseif file_name:match("%.jsx$") then
    return "```jsx"
  elseif file_name:match("%.java$") then
    return "```java"
  elseif file_name:match("%.py$") then
    return "```python"
  elseif file_name:match("%.css$") then
    return "```css"
  elseif file_name:match("%.html$") then
    return "```html"
  elseif file_name:match("%.lua$") then
    return "```lua"
  else
    -- Default fallback
    return "```"
  end
end

-- Helper function to get the project's directory tree.
-- You can customize the ignore list or depth flags as needed.
local function get_project_tree()
  -- Example ignoring node_modules, target, build, .git
  -- Adjust as necessary, or remove flags you don't need
  local ignore_list =
    "node_modules|dist|build|.git|.idea|__pycache__|migrations|venv|.pytest_cache|mediaroot|uploads|staticroot|.*.pdf|.*.jpg|.*.png"
  local tree_cmd = string.format("tree -I '%s'", ignore_list)

  -- Attempt to run the 'tree' command. Return nil if 'tree' not found.
  -- (If you want a friendlier error, add a check for `vim.fn.executable("tree")`)
  if vim.fn.executable("tree") == 0 then
    return nil
  end

  local output = vim.fn.systemlist(tree_cmd)
  if not output or #output == 0 then
    return nil
  end
  return output
end

local function copy_open_buffers_to_clipboard()
  local buffer_contents = {}

  -- 1) Insert a helpful prompt header
  table.insert(
    buffer_contents,
    [[
## Problem Description:


## Error Message (If applicable):

## Relevant Files
]]
  )

  -- 2) Insert a Project Directory Tree section (if available)
  local project_tree = get_project_tree()
  if project_tree then
    -- We add a helpful heading and a text code fence
    local tree_section = {
      "### Project Directory Tree",
      "```text",
      table.concat(project_tree, "\n"),
      "```",
    }
    table.insert(buffer_contents, table.concat(tree_section, "\n"))
  end

  -- 3) Loop through all “listed” buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      if buftype == "" then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines > 0 then
            -- Format each file as a section with code fences
            local fence = guess_language(name)
            local content = table.concat(lines, "\n")
            local file_section = string.format(
              [[
### File: %s
%s
%s
```]],
              name,
              fence,
              content
            )
            table.insert(buffer_contents, file_section)
          end
        end
      end
    end
  end

  -- 4) Join everything with a separator (optional)
  local final = table.concat(buffer_contents, "\n***\n")

  -- 5) Copy to system clipboard
  vim.fn.setreg("+", final)

  -- 6) Optional message
  print("All open file buffers (and project tree) copied to clipboard in a chat-friendly format.")
end

-- Create a user command
vim.api.nvim_create_user_command("CopyBuffers", function()
  copy_open_buffers_to_clipboard()
end, {})

-- Optional: Create a key mapping (<leader>cb)
vim.keymap.set("n", "<leader>cb", copy_open_buffers_to_clipboard, {
  desc = "Copy all open buffers to clipboard (with code fences and project tree)",
})
