return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Start Markdown files in raw/editing mode.
      enabled = false,

      -- When rendering is enabled, keep it rendered in every mode.
      -- Prevents things changing when entering insert mode.
      render_modes = true,

      -- Don't reveal raw syntax just because the cursor is on that line.
      anti_conceal = {
        enabled = false,
      },

      -- Raw mode should actually look raw.
      -- Rendered mode conceals Markdown syntax.
      win_options = {
        conceallevel = {
          default = 0,
          rendered = 3,
        },
        concealcursor = {
          default = "",
          rendered = "",
        },
      },

      heading = {
        sign = false,

        -- Don't add extra heading icons.
        icons = {},

        -- Avoid the giant full-width colored bars.
        width = "block",

        position = "inline",
        left_pad = 0,
        right_pad = 1,
      },

      code = {
        sign = false,

        -- Only make the background as wide as the code.
        width = "block",

        -- Cleaner looking code blocks.
        border = "thin",
        left_pad = 1,
        right_pad = 1,
      },

      checkbox = {
        enabled = false,
      },
    },
  },
}
