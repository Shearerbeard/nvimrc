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
      map("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })
      map("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
    end,
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- DAP (Debug Adapter Protocol)
  {
    "mfussenegger/nvim-dap",
    ft = { "go", "rust" }, -- Load for Go and Rust files
    init = function()
      -- Load your keymappings here
      local map = vim.keymap.set
      map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
      map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { desc = "Continue" })
      map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { desc = "Step Over" })
      map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { desc = "Step Into" })
      map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
    end,
    config = function()
      local dap = require("dap")

      -- Rust debugging with codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.exepath("codelldb") ~= "" and vim.fn.exepath("codelldb")
            or vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Launch with args",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }
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
      require("copilot").setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
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
      provider = "gemini",
      mode = "agentic",
      -- Claude with thinking mode
      providers = {
        claude = {
          -- model = "claude-3-7-sonnet-20250219",
          model = "claude-sonnet-4-20250514",
          thinking = {
            type = "enabled",
            budget_tokens = 2048,
          },
          extra_request_body = {
            temperature = 1,
            max_tokens = 20480,
          },
          -- Endpoint omitted - will use default https://api.anthropic.com
        },

        -- OpenAI configuration
        openai = {
          model = "gpt-4.1",
          max_tokens = 4096,
          extra_request_body = {
            temperature = 0.1,
          },
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
          -- model = "gemini-2.5-flash",
          -- model = "gemini-2.0-pro-exp-02-05"
          model = "gemini-2.5-pro",
          thinking = {
            type = "enabled",
          },
          -- Endpoint omitted - will use Google's default API endpoint
        },

        -- Ollama
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          timeout = 30000, -- Timeout in milliseconds
          model = "deepseek-coder-v2:latest",
          extra_request_body = {
            options = {
              temperature = 0.75,
              num_ctx = 20480,
              keep_alive = "4m",
            },
          },
        },
      },
      web_search_engine = {
        provider = "searxng",
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

  -- Rust development plugins
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false, -- Load immediately for Rust files
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Use NvChad's on_attach for keymaps and capabilities
            require("nvchad.configs.lspconfig").on_attach(client, bufnr)

            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end,
          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
                allFeatures = true,
                extraArgs = { "--all-targets" },
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                bindingModeHints = { enable = true },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 10 },
                closureReturnTypeHints = { enable = "with_block" },
                discriminantHints = { enable = "fieldless" },
                expressionAdjustmentHints = { enable = "reborrow" },
                lifetimeElisionHints = { enable = "skip_trivial" },
                parameterHints = { enable = true },
                reborrowHints = { enable = "mutable" },
                renderColons = true,
                typeHints = {
                  enable = true,
                  hideClosureInitialization = false,
                  hideNamedConstructor = false,
                },
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
              completion = {
                postfix = {
                  enable = true,
                },
                autoimport = {
                  enable = true,
                },
              },
              lens = {
                enable = true,
                references = {
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
              },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml dependency management
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup({
        -- Use LSP-based completion instead of deprecated cmp completion
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end,
  },
}
