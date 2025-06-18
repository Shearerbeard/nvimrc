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


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
