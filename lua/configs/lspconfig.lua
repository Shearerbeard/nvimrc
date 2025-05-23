-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "rust_analyzer",
  "dockerls",
  "docker_compose_language_service",
  "ts_ls",
  "hls",
  "gopls",
  "denols"
}

local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  if lsp == "rust_analyzer" then
    lspconfig.rust_analyzer.setup {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
            allFeatures = true,
            loadOutDirsFromCheck = true,
          },
          cargo = {
            allFeatures = true,
          },
          procMacro = {
            enable = true,
          }
        },
      },
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  elseif lsp == "denols" then
      lspconfig.denols.setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        init_options = {
          enable = true,
          lint = true,
          unstable = false,
        }
      }
  else
    lspconfig[lsp].setup {
      on_attach = nvlsp.on_attach,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
end

