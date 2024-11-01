return {
  {
    "mfussenegger/nvim-dap",
    version = "*",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP: Continue execution",
      },
      {
        "<Leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP: Add/remove breakpoint into the current line",
      },
    },
    config = function()
      local dap = require("dap")
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "nvim-dap",
    keys = {
      {
        "<Leader>dg",
        function()
          require("dapui").toggle({})
        end,
        desc = "DAP: Toggle DAP GUI",
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
    opts = { ... },
  },
}
