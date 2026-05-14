require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt ='both' -- to enable cursorline!

-- Clipboard configuration for tmux + Ghostty
-- Use OSC 52 to integrate with system clipboard through terminal
o.clipboard = "unnamedplus"

-- Enable OSC 52 clipboard provider for remote/tmux sessions
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy,
    ["*"] = require("vim.ui.clipboard.osc52").copy,
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste,
    ["*"] = require("vim.ui.clipboard.osc52").paste,
  },
}
