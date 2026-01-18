return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          -- Disable auto_open so it doesn't pop up automatically
          auto_open = {
            enabled = false,
          },
        },
      },
    },
  },
}
