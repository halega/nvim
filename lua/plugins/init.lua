return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "sql",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      -- Цвет для точек останова (красный из темы NvChad или конкретный hex)
      vim.api.nvim_set_hl(0, "DapBreakpointColor", { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "DapBreakpointRejectedColor", { fg = "#5c6370" })

      -- Обычная точка останова (красная точка)
      vim.fn.sign_define("DapBreakpoint", {
        text = "●", -- или "" / "" если установлен Nerd Font
        texthl = "DapBreakpointColor",
        linehl = "",
        numhl = "DapBreakpointColor",
      })

      -- Условная точка останова (Conditional Breakpoint)
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "◆",
        texthl = "DapBreakpointColor",
        linehl = "",
        numhl = "DapBreakpointColor",
      })

      -- Неактивная / отклонённая точка (например, в коде без отладочных символов)
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "○",
        texthl = "DapBreakpointRejectedColor",
        linehl = "",
        numhl = "",
      })

      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#4f4f1c", bold = true })
      vim.fn.sign_define("DapStopped", {
        text = "▶",
        texthl = "DiagnosticWarn",
        linehl = "DapStoppedLine",
        numhl = "DiagnosticWarn",
      })
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
  {
    "nvim-neotest/neotest",
    ft = "go",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
    },
    keys = {
      {
        "<leader>gt",
        function()
          require("neotest").run.run()
        end,
        desc = "Go: Run nearest test",
      },
      {
        "<leader>gT",
        function()
          require("neotest").run.run(vim.fn.expand "%")
        end,
        desc = "Go: Run test file",
      },
      {
        "<leader>go",
        function()
          require("neotest").output.open { enter = true }
        end,
        desc = "Go: Test output",
      },
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "neotest-golang" {},
        },
      }
    end,
  },
}
