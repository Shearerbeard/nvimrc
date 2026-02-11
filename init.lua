vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Load environment variables from shell config files (needed for GUI launches)
local function parse_env_file(filepath)
  if vim.fn.filereadable(filepath) ~= 1 then
    return false
  end
  local lines = vim.fn.readfile(filepath)
  for _, line in ipairs(lines) do
    if not line:match("^%s*$") and not line:match("^%s*#") then
      local key, value = line:match("^%s*export%s+([A-Z][A-Z_0-9]*)%s*=%s*(.*)$")
      if not key then
        key, value = line:match("^%s*([A-Z][A-Z_0-9]*)%s*=%s*(.*)$")
      end
      if key and value then
        if value:match('^".*"$') then
          value = value:sub(2, -2)
        elseif value:match("^'.*'$") then
          value = value:sub(2, -2)
        end
        value = vim.fn.expand(value)
        vim.env[key] = value
      end
    end
  end
  return true
end

local shell = os.getenv("SHELL") or ""
local loaded = false
if shell:match("zsh") then
  loaded = parse_env_file(vim.fn.expand("~/.zshenv"))
end
if not loaded and shell:match("bash") then
  loaded = parse_env_file(vim.fn.expand("~/.bash_profile"))
    or parse_env_file(vim.fn.expand("~/.bashrc"))
end
if not loaded then
  parse_env_file(vim.fn.expand("~/.profile"))
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
