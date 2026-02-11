require "nvchad.mappings"

-- Override NvChad defaults that conflict with our keybinding groups
local del = vim.keymap.del
del("n", "<leader>h")  -- was: horizontal terminal (shadows <leader>h* Haskell group)
del("n", "<leader>v")  -- was: vertical terminal (shadows <leader>v* if ever used)

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>tt", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle NvimTree" })
map("n", "<leader>tf", "<cmd> NvimTreeFocus <CR>", { desc = "Focus NvimTree" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "Telescope References" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Telescope Document Symbols" })
map({ "n", "v" }, "<leader>la",
  function ()
    vim.lsp.buf.code_action()
  end,
  { desc = "LSP Code Action" }
)

-- Inlay hints toggle
map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

map({ "n", "x" }, "<leader>lf", function()
  require("conform").format { lsp_format = "fallback" }
end, { desc = "Format File" })

-- Rust-specific keymaps (only work in Rust files)
map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", { desc = "Rust Runnables" })
map("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", { desc = "Rust Debuggables" })
map("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", { desc = "Rust Expand Macro" })
map("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", { desc = "Rust Open Cargo.toml" })
map("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", { desc = "Rust Parent Module" })
map("n", "<leader>rm", "<cmd>RustLsp rebuildProcMacros<cr>", { desc = "Rust Rebuild Proc Macros" })
map("n", "<leader>rE", "<cmd>RustLsp explainError<cr>", { desc = "Rust Explain Error" })
map("n", "<leader>rt", "<cmd>RustLsp testables<cr>", { desc = "Rust Testables" })
map("n", "<leader>rj", "<cmd>RustLsp joinLines<cr>", { desc = "Rust Join Lines" })
map("n", "<leader>rh", "<cmd>RustLsp hover actions<cr>", { desc = "Rust Hover Actions" })

-- Haskell-specific keymaps (<leader>h*)
map("n", "<leader>hr", function()
  require("haskell-tools").repl.toggle()
end, { desc = "Haskell REPL Toggle" })
map("n", "<leader>hR", function()
  require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
end, { desc = "Haskell REPL for Buffer" })
map("n", "<leader>hh", function()
  require("haskell-tools").hoogle.hoogle_signature()
end, { desc = "Hoogle Signature Search" })
map("n", "<leader>he", function()
  require("haskell-tools").lsp.buf_eval_all()
end, { desc = "Evaluate All Code Lenses" })
map("n", "<leader>hp", function()
  require("haskell-tools").project.open_package_yaml()
end, { desc = "Open package.yaml" })
map("n", "<leader>hc", function()
  require("haskell-tools").project.open_package_cabal()
end, { desc = "Open .cabal file" })

-- Git signs keymaps
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Git Hunk" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
map("n", "<leader>gh", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Git Hunk" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Git Hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous Git Hunk" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" })
map("n", "<leader>gU", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo Stage Hunk" })
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff This" })
map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle Line Blame" })

-- LSP Code Lens
map("n", "<leader>lc", function()
  vim.lsp.codelens.run()
end, { desc = "Run Code Lens" })
map("n", "<leader>lC", function()
  vim.lsp.codelens.refresh()
end, { desc = "Refresh Code Lenses" })

-- Diagnostic keymaps (additional to NvChad defaults)
map("n", "<leader>ld", "<cmd>Telescope diagnostics<cr>", { desc = "List Diagnostics" })
map("n", "<leader>ll", function()
  vim.diagnostic.open_float()
end, { desc = "Show Line Diagnostics" })

-- Python-specific keymaps
map("n", "<leader>pr", function()
  vim.cmd("split | terminal python3 %")
end, { desc = "Run Python File" })
map("n", "<leader>pi", function()
  vim.cmd("split | terminal python3")
end, { desc = "Python Interactive Shell" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Avante keymaps (<leader>a for Avante, <leader>c for Claude Code)
map("n", "<leader>az", function()
  require("avante.api").zen_mode()
end, { desc = "Avante Zen Mode" })
map("n", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante Ask" })
map("n", "<leader>at", "<cmd>AvanteToggle<cr>", { desc = "Avante Toggle" })
map("n", "<leader>am", "<cmd>AvanteModels<cr>", { desc = "Avante Models" })
map("n", "<leader>ap", "<cmd>AvanteProfile<cr>", { desc = "Avante Profile" })
map("v", "<leader>aa", "<cmd>AvanteAsk<cr>", { desc = "Avante Ask (selection)" })
map("v", "<leader>ae", "<cmd>AvanteEdit<cr>", { desc = "Avante Edit (selection)" })
