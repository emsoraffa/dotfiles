return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "copilot-chat" },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    opts = {
      highlight_headers = false,
      error_header = "> [!ERROR] Error",
      headers = {
        user = "👤 You",
        assistant = "🤖 Copilot",
        tool = "🔧 Tool",
      },
      window = {
        layout = "float",
        relative = "cursor",
        width = 1,
        height = 0.4,
        row = 1,
        border = "rounded", -- 'single', 'double', 'rounded', 'solid'
        title = "🤖 AI Assistant",
        zindex = 100, -- Ensure window stays on top
      },

      separator = "━━",
      auto_fold = true,

      build = "make tiktoken",
      prompts = {
        MyCustomPrompt = {
          description = "Tutor",
          prompt = "Ignore previous instructions. You are an AI assistant acting as a private teacher. Your role is to guide, explain, and help the user learn concepts, best practices, and approaches. Do not produce code solutions or snippets tailored to the user's specific problem. When asked for examples, provide only generic, illustrative code using placeholder names (e.g., foo, bar, baz) and avoid solving the user's actual task. Focus on teaching, clarifying, and enabling the user to solve problems independently. Never do the work for the user.",
          mapping = "<leader>ac",
        },
      },
    },
  },
}
