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
        desc = "gDAP: Continue execution",
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

      -- 1. Manually define the codelldb adapter, pointing to the executable Mason installed.
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb", -- This should be in your path if installed by Mason
          args = { "--port", "${port}" },
        },
      }

      -- 2. Change your C/C++ configuration to use "codelldb" instead of "gdb".
      dap.configurations.cpp = {
        {
          name = "Launch with LLDB",
          type = "codelldb", -- The only change needed here is this line
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = true,
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
