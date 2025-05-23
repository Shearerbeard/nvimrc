-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "oxocarbon",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

M.nvdash = { load_on_startup = true }
M.ui = {
      tabufline = {
         lazyload = false
     }
}

-- luacheck: globals Docker_Fix
function Docker_Fix()
  local filename = vim.fn.expand "%:t"

  if filename == "docker-compose.yaml" then
    vim.bo.filetype = "yaml.docker-compose"
  elseif filename == "docker-compose.yml" then
    vim.bo.filetype = "yaml.docker-compose"
  elseif filename == "compose.yaml" then
    vim.bo.filetype = "yaml.docker-compose"
  elseif filename == "compose.yml" then
    vim.bo.filetype = "yaml.docker-compose"
  end
end

vim.cmd [[au BufRead * lua Docker_Fix()]]

return M
