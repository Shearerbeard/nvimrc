-- Avante provider profiles
-- Switch with :AvanteProfile <name>

local M = {}

M.profiles = {
  -- Bedrock Claude (cost-effective)
  bedrock = {
    provider = "bedrock",
    cursor_applying_provider = "bedrock-haiku",
    auto_suggestions_provider = "bedrock-haiku",
    memory_summary_provider = "bedrock-haiku",
  },

  -- Bedrock Claude with Opus for main (premium)
  ["bedrock-opus"] = {
    provider = "bedrock-opus",
    cursor_applying_provider = "bedrock-haiku",
    auto_suggestions_provider = "bedrock-haiku",
    memory_summary_provider = "bedrock-haiku",
  },

  -- OpenAI GPT-5.2 (flagship)
  openai = {
    provider = "openai",
    cursor_applying_provider = "openai-5.1",
    auto_suggestions_provider = "openai-5.1",
    memory_summary_provider = "openai-5.1",
  },

  -- OpenAI GPT-5.2-Codex (coding optimized)
  ["openai-codex"] = {
    provider = "openai-codex",
    cursor_applying_provider = "openai-5.1",
    auto_suggestions_provider = "openai-5.1",
    memory_summary_provider = "openai-5.1",
  },

  -- Gemini 3 Pro
  gemini = {
    provider = "gemini",
    cursor_applying_provider = "gemini-flash",
    auto_suggestions_provider = "gemini-flash",
    memory_summary_provider = "gemini-flash",
  },

  -- Bedrock Qwen3-Coder (managed, great for coding)
  ["bedrock-qwen"] = {
    provider = "bedrock-qwen",
    cursor_applying_provider = "bedrock-qwen-30b",
    auto_suggestions_provider = "bedrock-qwen-30b",
    memory_summary_provider = "bedrock-qwen-30b",
  },

  -- Bedrock DeepSeek V3.1 (685B, excellent for coding)
  ["bedrock-deepseek"] = {
    provider = "bedrock-deepseek",
    cursor_applying_provider = "bedrock-haiku",
    auto_suggestions_provider = "bedrock-haiku",
    memory_summary_provider = "bedrock-haiku",
  },

  -- Local Qwen3-Coder 30B (fits 24GB, best open-source coding)
  ["qwen-local"] = {
    provider = "ollama",
    cursor_applying_provider = "ollama",
    auto_suggestions_provider = "ollama",
    memory_summary_provider = "ollama",
  },

  -- Local Devstral 24B (Mistral's coding model)
  ["devstral-local"] = {
    provider = "ollama-devstral",
    cursor_applying_provider = "ollama-devstral",
    auto_suggestions_provider = "ollama-devstral",
    memory_summary_provider = "ollama-devstral",
  },

  -- ACP: Claude Code CLI (uses claude auth, no API key needed)
  ["acp-claude"] = {
    provider = "claude-code",
    cursor_applying_provider = nil,
    auto_suggestions_provider = nil,
    memory_summary_provider = nil,
  },

  -- ACP: OpenCode CLI (multi-provider support)
  ["acp-opencode"] = {
    provider = "opencode",
    cursor_applying_provider = nil,
    auto_suggestions_provider = nil,
    memory_summary_provider = nil,
  },

  -- ACP: Gemini CLI
  ["acp-gemini"] = {
    provider = "gemini-cli",
    cursor_applying_provider = nil,
    auto_suggestions_provider = nil,
    memory_summary_provider = nil,
  },
}

function M.switch(profile_name)
  local profile = M.profiles[profile_name]
  if not profile then
    local available = table.concat(vim.tbl_keys(M.profiles), ", ")
    vim.notify("Unknown profile: " .. profile_name .. "\nAvailable: " .. available, vim.log.levels.ERROR)
    return
  end

  local config = require("avante.config")

  -- Update config
  for key, value in pairs(profile) do
    config.options[key] = value
  end

  vim.notify("Switched to Avante profile: " .. profile_name, vim.log.levels.INFO)
end

function M.setup()
  -- Create :AvanteProfile command
  vim.api.nvim_create_user_command("AvanteProfile", function(opts)
    if opts.args == "" then
      -- Show current and available profiles
      local current = require("avante.config").options.provider or "unknown"
      local available = table.concat(vim.tbl_keys(M.profiles), ", ")
      vim.notify("Current provider: " .. current .. "\nProfiles: " .. available, vim.log.levels.INFO)
    else
      M.switch(opts.args)
    end
  end, {
    nargs = "?",
    complete = function()
      return vim.tbl_keys(M.profiles)
    end,
    desc = "Switch Avante provider profile",
  })
end

return M
