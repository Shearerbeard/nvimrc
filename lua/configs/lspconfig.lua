-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- Define server configurations using vim.lsp.config
-- This is the new Neovim 0.11+ API that replaces require('lspconfig')

-- NOTE: rust_analyzer is now configured via rustaceanvim plugin
-- See lua/plugins/init.lua for Rust configuration

-- Configure denols with custom settings
vim.lsp.config("denols", {
  cmd = { "deno", "lsp" },
  root_markers = { "deno.json", "deno.jsonc" },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    enable = true,
    lint = true,
    unstable = false,
  }
})

-- Configure pyright with custom settings for Python
vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  settings = {
    pyright = {
      -- Use ruff for linting/formatting, pyright only for type checking
      disableOrganizeImports = true, -- Using ruff for this
    },
    python = {
      analysis = {
        typeCheckingMode = "basic", -- or "strict" for stricter checks
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
        -- Improve performance by ignoring some directories
        ignore = { "**/node_modules", "**/__pycache__", ".venv", "venv" },
      },
    },
  },
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure ruff for Python linting and formatting
vim.lsp.config("ruff", {
  cmd = { "ruff", "server", "--preview" },
  init_options = {
    settings = {
      -- Ruff server settings
      lineLength = 88,
      -- Enable auto-fixing on save
      fixAll = true,
      organizeImports = true,
    },
  },
  on_attach = function(client, bufnr)
    -- Disable hover in favor of pyright
    client.server_capabilities.hoverProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure servers with default settings
local simple_servers = {
  "html",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  "ts_ls",
  "hls",
  "gopls",
}

for _, server in ipairs(simple_servers) do
  vim.lsp.config(server, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

-- Enable all configured servers
-- Note: rust_analyzer is handled by rustaceanvim plugin
local all_servers = vim.list_extend(vim.deepcopy(simple_servers), { "denols", "pyright", "ruff" })
vim.lsp.enable(all_servers)

