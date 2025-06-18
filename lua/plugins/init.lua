return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults
        "vim",
        "lua",

        -- config / util / docs
        "bash",
        "json",
        "yaml",
        "toml",
        "csv",
        "markdown",
        "cue",
        "ssh_config",
        "dot",
        "cmake",
        "make",
        "git_config",
        "dockerfile",
        "gitignore",
        "vue",
        "regex",

        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "svelte",

        -- general
        "c",
        "cpp",
        "go",
        "haskell",
        "python",
        "sql",
        "rust",
      },
    },
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>op",
        function()
          local peek = require "peek"
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = { theme = "dark", app = "browser" },
  },
  {
    "charludo/projectmgr.nvim",
    lazy = false, -- important!
    keys = {
      { "<leader>pp", "<cmd> ProjectMgr<CR>", desc = "Open Projects" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    init = function()
      local map = vim.keymap.set
      map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
      map("n", "<leader>fT", "<cmd>TodoTrouble<cr>", { desc = "Todo Trouble" })
      map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
      map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
    end,
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    ft = "go", -- Load only for Go files
    init = function()
      -- Load your keymappings here
      local map = vim.keymap.set
      map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
      map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { desc = "Continue" })
      map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { desc = "Step Over" })
      map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { desc = "Step Into" })
      map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
    end,
  },
  -- Go DAP extension
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      -- require("dap-go")
      require "configs.dap-go" -- Import the config file
      require("dap-go").setup(opts)
    end,
  },
  -- Optional but recommended: UI for DAP
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap",
    },
    lazy = false,
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Apply the setup
      dapui.setup()

      -- Define keymaps AFTER requiring both modules
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "Toggle DAP UI" })

      -- Debug the keymap by printing when it's set
      print "DAP-UI keymap set: <leader>du"

      -- Add event listeners to automatically open UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        print "DAP-UI opened automatically"
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      -- provider = "openai",
      provider = "claude",
      mode = "agentic",
      -- Claude with thinking mode
      claude = {
        model = "claude-3-7-sonnet-20250219",
        temperature = 1,
        max_tokens = 4096,
        thinking = {
          type = "enabled",
          budget_tokens = 2048,
        },
        -- Endpoint omitted - will use default https://api.anthropic.com
      },

      -- OpenAI configuration
      openai = {
        model = "gpt-4.1",
        temperature = 0.1,
        max_tokens = 4096,
        -- Endpoint omitted - will use default https://api.openai.com
      },

      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4",
        proxy = nil,
        allow_insecure = false,
        timeout = 30000,
      },

      -- Gemini configuration
      gemini = {
        -- model = "gemini-2.5-pro",
        temperature = 0.1,
        max_tokens = 4096,
        -- Endpoint omitted - will use Google's default API endpoint
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
