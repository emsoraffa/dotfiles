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

  -- 2) Loop through all “listed” buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1 then
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      if buftype == "" then
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines > 0 then
            -- 3) Format each file as a section with code fences
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
  print("All open file buffers copied to clipboard in a chat-friendly format.")
end

-- Create a user command
vim.api.nvim_create_user_command("CopyBuffers", function()
  copy_open_buffers_to_clipboard()
end, {})

-- Optional: Create a key mapping (<leader>cb)
vim.keymap.set("n", "<leader>cb", copy_open_buffers_to_clipboard, {
  desc = "Copy all open buffers to clipboard (with code fences)",
})
