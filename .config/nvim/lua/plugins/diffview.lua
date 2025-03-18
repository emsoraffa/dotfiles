return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>gd",
        function()
          require("diffview").open(get_main_branch() .. "..HEAD")
        end,
        desc = "Diff branch vs main/master",
      },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
      {
        "<leader>gm",
        function()
          require("diffview").open("origin/" .. get_main_branch() .. "...HEAD")
        end,
        desc = "Diff branch vs merge base",
      },
      { "<leader>gz", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      {
        "<leader>ge",
        function()
          open_file_in_buffer()
        end,
        desc = "Open file in regular buffer",
      },
    },
    config = function()
      require("diffview").setup({
        keymaps = {
          file_panel = {
            ["<leader>ge"] = function()
              open_file_in_buffer()
            end, -- Bind in file panel too
          },
        },
      })

      -- Function to detect main branch
      _G.get_main_branch = function()
        local branches = vim.fn.systemlist("git branch -r")
        for _, branch in ipairs(branches) do
          if branch:match("origin/main") then
            return "main"
          elseif branch:match("origin/master") then
            return "master"
          end
        end
        return "main"
      end

      -- Function to open the focused file in a regular buffer
      _G.open_file_in_buffer = function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view and view.panel then
          local file = view.panel:cur_item() -- Get the current file entry from the file panel
          if file and file.path then
            vim.cmd("DiffviewClose") -- Close Diffview
            vim.cmd("edit " .. file.path) -- Open the file in a regular buffer
          else
            print("No file selected in Diffview file panel")
          end
        else
          print("No Diffview open or not in file panel")
        end
      end
    end,
  },
}
