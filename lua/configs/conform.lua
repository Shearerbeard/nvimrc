local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    rust = { "rustfmt" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    go = { "gofmt", "golangci-lint" },
    haskell = { "fourmolu" },
    terraform = { "terraform_fmt" },
    python = { "ruff_format", "ruff_organize_imports" },
  },
}

return options
