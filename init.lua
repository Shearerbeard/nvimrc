vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- mac iterm2 zshenv fix
local is_macos = vim.loop.os_uname().sysname == "Darwin"

if is_macos then
  -- print("Running on macOS - loading environment variables from .zshenv...")

  -- Read .zshenv file directly
  local zshenv_path = vim.fn.expand("~/.zshenv")

  if vim.fn.filereadable(zshenv_path) == 1 then
    local lines = vim.fn.readfile(zshenv_path)

    for _, line in ipairs(lines) do
      -- Skip empty lines and comments
      if not line:match("^%s*$") and not line:match("^%s*#") then
        -- Match variable assignments: KEY_NAME=value or export KEY_NAME=value
        local key, value = line:match("^%s*export%s+([A-Z][A-Z_0-9]*)%s*=%s*(.*)$")
        if not key then
          key, value = line:match("^%s*([A-Z][A-Z_0-9]*)%s*=%s*(.*)$")
        end

        if key and value then
          -- Remove surrounding quotes if present
          if value:match('^".*"$') then
            value = value:sub(2, -2)
          elseif value:match("^'.*'$") then
            value = value:sub(2, -2)
          end

          -- Expand variables like $HOME
          value = vim.fn.expand(value)

          vim.env[key] = value
        end
      end
    end
  else
    print("Could not read ~/.zshenv")
  end
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
