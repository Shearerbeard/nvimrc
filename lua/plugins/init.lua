return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Terminal toggle (required by haskell-tools repl)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    opts = {
      open_mapping = [[<C-\>]],
      direction = "horizontal",
      size = 15,
    },
  },

  -- Seamless navigation between tmux panes and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
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
    keys = {
      { "<leader>pp", "<cmd> ProjectMgr<CR>", desc = "Open Projects" },
    },
    opts = {},
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
    ft = { "go", "rust", "python", "haskell" }, -- Load for Go, Rust, Python, and Haskell files
    init = function()
      -- Load your keymappings here
      local map = vim.keymap.set
      map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle Breakpoint" })
      map("n", "<leader>dc", ":lua require'dap'.continue()<CR>", { desc = "Continue" })
      map("n", "<leader>do", ":lua require'dap'.step_over()<CR>", { desc = "Step Over" })
      map("n", "<leader>di", ":lua require'dap'.step_into()<CR>", { desc = "Step Into" })
      map("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
      map("n", "<leader>dO", ":lua require'dap'.step_out()<CR>", { desc = "Step Out" })
      map("n", "<leader>dt", ":lua require'dap'.terminate()<CR>", { desc = "Terminate" })
      map("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>", { desc = "Conditional Breakpoint" })
      map("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { desc = "Run Last" })
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

      -- Python debugging with debugpy
      dap.adapters.python = {
        type = "executable",
        command = vim.fn.exepath("python3"),
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Use virtual environment if available
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return vim.fn.exepath("python3")
            end
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file with args",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ")
          end,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return vim.fn.exepath("python3")
            end
          end,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = function()
            local host = vim.fn.input("Host [127.0.0.1]: ")
            host = host ~= "" and host or "127.0.0.1"
            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
            return { host = host, port = port }
          end,
        },
      }

      -- Haskell debugging with haskell-debug-adapter
      dap.adapters.haskell = {
        type = "executable",
        command = "haskell-debug-adapter",
        args = { "--hackage-version=0.0.33.0" },
      }

      dap.configurations.haskell = {
        {
          type = "haskell",
          request = "launch",
          name = "Launch (stack)",
          workspace = "${workspaceFolder}",
          startup = "${file}",
          stopOnEntry = true,
          logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
          logLevel = "WARNING",
          ghciEnv = vim.empty_dict(),
          ghciPrompt = "λ: ",
          ghciInitialPrompt = "λ: ",
          ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
        },
        {
          type = "haskell",
          request = "launch",
          name = "Launch (cabal)",
          workspace = "${workspaceFolder}",
          startup = "${file}",
          stopOnEntry = true,
          logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
          logLevel = "WARNING",
          ghciEnv = vim.empty_dict(),
          ghciPrompt = "λ: ",
          ghciInitialPrompt = "λ: ",
          ghciCmd = "cabal repl --repl-options=-fprint-evld-with-show",
        },
      }
    end,
  },
  -- Go DAP extension
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug Test (Go)", ft = "go" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Test (Go)", ft = "go" },
    },
    config = function()
      local opts = require "configs.dap-go"
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
    ft = { "go", "rust", "python", "haskell" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Apply the setup
      dapui.setup()

      -- Define keymaps AFTER requiring both modules
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "Toggle DAP UI" })

      -- Add event listeners to automatically open UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
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
      -- Default config (can be overridden by :AvanteProfile command)
      provider = "bedrock",
      cursor_applying_provider = "bedrock-haiku",
      auto_suggestions_provider = "bedrock-haiku",
      memory_summary_provider = "bedrock-haiku",
      mode = "agentic",

      -- MCP Hub integration (LSP diagnostics, tools, resources)
      system_prompt = function()
        local ok, hub = pcall(function() return require("mcphub").get_hub_instance() end)
        return ok and hub and hub:get_active_servers_prompt() or ""
      end,
      custom_tools = function()
        local ok, tool = pcall(function() return require("mcphub.extensions.avante").mcp_tool() end)
        return ok and tool and { tool } or {}
      end,
      -- Claude with thinking mode
      providers = {
        -- Claude 4.5 Sonnet (balanced speed/intelligence)
        claude = {
          model = "claude-sonnet-4-5-20250929",
          thinking = {
            type = "enabled",
            budget_tokens = 4096,
          },
          extra_request_body = {
            temperature = 1,
            max_tokens = 32768,
          },
        },

        -- Claude 4.5 Opus (most capable)
        ["claude-opus"] = {
          __inherited_from = "claude",
          model = "claude-opus-4-5-20251101",
        },

        -- Claude 4.5 Haiku (fastest)
        ["claude-haiku"] = {
          __inherited_from = "claude",
          model = "claude-haiku-4-5-20251001",
        },

        -- OpenAI GPT-5.2 (latest flagship)
        openai = {
          model = "gpt-5.2",
          max_tokens = 16384,
          extra_request_body = {
            temperature = 0.1,
          },
        },

        -- OpenAI GPT-5.1 (balanced, faster)
        ["openai-5.1"] = {
          __inherited_from = "openai",
          model = "gpt-5.1",
        },

        -- OpenAI GPT-5.1-Codex (coding optimized, API available)
        ["openai-codex"] = {
          __inherited_from = "openai",
          model = "gpt-5.1-codex",
        },

        -- OpenAI GPT-5.1-Codex-Max (extended context/capability)
        ["openai-codex-max"] = {
          __inherited_from = "openai",
          model = "gpt-5.1-codex-max",
        },

        -- NOTE: gpt-5.2-codex not yet available via API (ChatGPT/Codex app only)

        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-5.2",
          proxy = nil,
          allow_insecure = false,
          timeout = 30000,
        },

        -- Gemini 3 Pro (reasoning-first, 1M context)
        gemini = {
          model = "gemini-3-pro-preview",
          thinking = {
            type = "enabled",
          },
        },

        -- Gemini 3 Flash (faster, cheaper)
        ["gemini-flash"] = {
          __inherited_from = "gemini",
          model = "gemini-3-flash-preview",
        },

        -- Ollama - Qwen3-Coder 30B (fits 24GB, best open-source coding)
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          timeout = 30000,
          model = "qwen3-coder:30b",
          extra_request_body = {
            options = {
              temperature = 0.7,
              top_p = 0.8,
              top_k = 20,
              num_ctx = 32768,
              keep_alive = "4m",
            },
          },
        },

        -- Devstral 24B (Mistral's coding model)
        ["ollama-devstral"] = {
          __inherited_from = "ollama",
          model = "devstral:24b",
        },

        -- AWS Bedrock providers (using inference profile IDs with us. prefix)
        bedrock = {
          model = "us.anthropic.claude-sonnet-4-5-20250929-v1:0",
          aws_region = os.getenv("AWS_REGION") or "us-east-1",
          aws_profile = os.getenv("AWS_PROFILE") or "default",
        },

        -- Bedrock Claude Opus
        ["bedrock-opus"] = {
          __inherited_from = "bedrock",
          model = "us.anthropic.claude-opus-4-5-20251101-v1:0",
        },

        -- Bedrock Claude Haiku (fast/cheap)
        ["bedrock-haiku"] = {
          __inherited_from = "bedrock",
          model = "us.anthropic.claude-haiku-4-5-20251001-v1:0",
        },

        -- NOTE: Bedrock Qwen/Mistral removed - Avante only has Claude handler

        -- Bedrock DeepSeek V3 (coding model)
        ["bedrock-deepseek"] = {
          __inherited_from = "bedrock",
          model = "us.deepseek.deepseek-v3-0324-v1:0",
          disable_tools = true,
        },

        -- NOTE: Bedrock Llama removed - expects raw prompt format, not Messages API
      },
      -- Web search: brave (fastest, best quality) or tavily (AI-optimized)
      -- Requires BRAVE_API_KEY or TAVILY_API_KEY env var
      web_search_engine = {
        provider = "brave", -- brave, tavily, kagi, google, serpapi, searxng
      },

      -- ACP providers (external coding CLIs)
      acp_providers = {
        ["claude-code"] = {
          command = "claude",
          args = { "acp" },
        },
        ["opencode"] = {
          command = "opencode",
          args = { "acp" },
        },
        ["gemini-cli"] = {
          command = "gemini",
          args = { "--experimental-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
          },
        },
      },

      behaviour = {
        auto_approve_tool_permissions = false,
        confirmation_ui_style = "inline_buttons",
        acp_follow_agent_locations = true,
      },

      -- Prompt logger for debugging/replay
      prompt_logger = {
        enabled = true,
        log_dir = vim.fn.stdpath("cache") .. "/avante_prompts",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    config = function(_, opts)
      require("avante").setup(opts)
      require("configs.avante-profiles").setup()
    end,
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
      "ravitemer/mcphub.nvim", -- MCP Hub integration
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

  -- Haskell development plugins
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^4",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    init = function()
      local nvlsp = require("nvchad.configs.lspconfig")

      vim.g.haskell_tools = {
        hls = {
          on_attach = function(client, bufnr, ht_opts)
            -- Use NvChad's on_attach for keymaps and capabilities
            nvlsp.on_attach(client, bufnr)

            -- Enable inlay hints
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end,
          capabilities = nvlsp.capabilities,
          settings = {
            haskell = {
              -- Formatter (fourmolu configured in conform.nvim)
              formattingProvider = "fourmolu",
              -- Enable all HLS plugins
              plugin = {
                -- Type lenses (show type signatures)
                class = { codeLensOn = true },
                -- Import lenses
                importLens = { codeLensOn = true },
                -- Refactor tools
                refineImports = { codeLensOn = true },
                -- hlint integration
                hlint = { globalOn = true },
                -- Eval plugin (evaluate code in comments)
                eval = { globalOn = true },
                -- Module name suggestions
                moduleName = { globalOn = true },
                -- Pragmas completions
                pragmas = { globalOn = true },
                -- Rename plugin
                rename = { globalOn = true },
                -- Retrie refactoring
                retrie = { globalOn = true },
                -- Splice plugin (Template Haskell)
                splice = { globalOn = true },
                -- Tactics/Wingman for code generation
                tactics = { globalOn = true },
              },
              -- Check the project on save
              checkProject = true,
            },
          },
        },
        tools = {
          -- Hoogle integration
          hoogle = {
            mode = "auto", -- 'auto', 'telescope-local', 'telescope-web', 'browser'
          },
          -- REPL tools
          repl = {
            handler = "toggleterm", -- 'builtin' or 'toggleterm'
            prefer = function()
              -- Prefer cabal if cabal.project exists, otherwise stack
              if vim.fn.filereadable("cabal.project") == 1 then
                return "cabal"
              elseif vim.fn.filereadable("stack.yaml") == 1 then
                return "stack"
              else
                return "cabal"
              end
            end,
          },
          -- Code lens
          codeLens = {
            autoRefresh = true,
          },
          -- Definition handler
          definition = {
            hoogle_signature_fallback = true,
          },
        },
      }
    end,
  },

  -- Rust development plugins
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    init = function()
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
    keys = {
      { "<leader>Rc", function() require("crates").show_crate_popup() end, desc = "Show Crate Info", ft = "toml" },
      { "<leader>Rv", function() require("crates").show_versions_popup() end, desc = "Show Versions", ft = "toml" },
      { "<leader>Rf", function() require("crates").show_features_popup() end, desc = "Show Features", ft = "toml" },
      { "<leader>Ru", function() require("crates").update_crate() end, desc = "Update Crate", ft = "toml" },
      { "<leader>Ra", function() require("crates").update_all_crates() end, desc = "Update All Crates", ft = "toml" },
    },
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

  -- MCP Hub - manage MCP servers for AI assistants
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- mcp-hub should be pre-installed via mise (npm install -g mcp-hub@latest)
    build = "npm install -g mcp-hub@latest || true",
    config = function()
      require("mcphub").setup({
        -- Auto-start servers when needed
        auto_start = true,
        -- Extensions for chat plugins
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
      })
    end,
    keys = {
      { "<leader>mh", "<cmd>MCPHub<cr>", desc = "MCP Hub" },
    },
  },

  -- MCP Diagnostics - share LSP diagnostics with AI
  {
    "georgeharker/mcp-diagnostics.nvim",
    dependencies = { "ravitemer/mcphub.nvim" },
    event = "LspAttach",
    config = function()
      require("mcp-diagnostics").setup({
        mode = "mcphub",
      })
    end,
  },

  -- Claude Code integration (edit from Claude CLI)
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    -- config = true,
    lazy = false,
    opts = {
      auto_start = true,
      diff = {
        open_in_new_tab = true,  -- Full tab for cleaner diff view
      },
    },
    keys = {
      { "<leader>c", nil, desc = "Claude Code" },
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
      { "<leader>cM", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      { "<leader>cs", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" } },
      { "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
