return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}

      -- Make each column narrower and leave a nice gap between them.
      opts.dashboard.width = 48
      opts.dashboard.pane_gap = 8

      -- Keep all of LazyVim's existing dashboard keys/picker config,
      -- but replace the header.
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = [[

 _   _ _____ ___  _   _ ___ __  __
| \ | | ____/ _ \| | | |_ _|  \/  |
|  \| |  _|| | | | | | || || |\/| |
| |\  | |__| |_| | |_| || || |  | |
|_| \_|_____\___/ \___/|___|_|  |_|

]]
      -- Make shortcut keys look like [f], [g], etc.
      opts.dashboard.formats = opts.dashboard.formats or {}
      opts.dashboard.formats.key = function(item)
        return {
          { "[", hl = "special" },
          { item.key, hl = "key" },
          { "]", hl = "special" },
        }
      end

      opts.dashboard.sections = {
        -- LEFT PANE
        {
          section = "header",
          padding = 1,
        },

        {
          section = "keys",
          gap = 1,
          padding = 1,
        },

        {
          section = "startup",
        },

        -- RIGHT PANE
        -- Recent files from the current Git repo, not from your whole machine.
        function()
          local root = Snacks.git.get_root() or vim.fn.getcwd()

          return {
            pane = 2,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            cwd = root,
            limit = 7,
            indent = 2,
            padding = 1,
          }
        end,

        -- Live-ish Git status for the project you're in.
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",

          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,

          cmd = "git status --short --branch --renames",
          height = 7,
          indent = 2,
          padding = 1,

          -- Cache it briefly so opening the dashboard stays fast.
          ttl = 30,
        },

        {
          pane = 2,
          icon = " ",
          title = "Recent Projects",
          section = "projects",
          limit = 4,
          indent = 2,
          padding = 1,
        },
      }

      return opts
    end,
  },
}
