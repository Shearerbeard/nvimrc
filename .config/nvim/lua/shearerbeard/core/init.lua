-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- BASE
vim.g.mapleader = ' '
vim.opt.termguicolors = true


require("shearerbeard.core.keybind")
