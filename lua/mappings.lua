require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>tt", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle NvimTree" })
map("n", "<leader>tf", "<cmd> NvimTreeFocus <CR>", { desc = "Focus NvimTree" })
map("n", "<leader>gr", "<cmd>Telescope lsp_references<cr>", { desc = "Telescope References" })
map("n", "<leader>gs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Telescope References" })
map("", "<leader>ca",
  function ()
    vim.lsp.buf.code_action()
  end,
  { desc = "LSP code action" }
)

-- Inlay hints toggle
map("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Rust-specific keymaps (only work in Rust files)
map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", { desc = "Rust Runnables" })
map("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>", { desc = "Rust Debuggables" })
map("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", { desc = "Rust Expand Macro" })
map("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", { desc = "Rust Open Cargo.toml" })
map("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", { desc = "Rust Parent Module" })
map("n", "<leader>rm", "<cmd>RustLsp rebuildProcMacros<cr>", { desc = "Rust Rebuild Proc Macros" })

-- Git signs keymaps
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Git Hunk" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git Blame Line" })
map("n", "<leader>gh", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Git Hunk" })
map("n", "]h", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next Git Hunk" })
map("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous Git Hunk" })

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

-- Avante keymaps (<leader>v for aVante, <leader>c for Claude Code)
map("n", "<leader>vz", function()
  require("avante.api").zen_mode()
end, { desc = "Avante Zen Mode" })
map("n", "<leader>va", "<cmd>AvanteAsk<cr>", { desc = "Avante Ask" })
map("n", "<leader>vt", "<cmd>AvanteToggle<cr>", { desc = "Avante Toggle" })
map("n", "<leader>vm", "<cmd>AvanteModels<cr>", { desc = "Avante Models" })
map("n", "<leader>vp", "<cmd>AvanteProfile<cr>", { desc = "Avante Profile" })
