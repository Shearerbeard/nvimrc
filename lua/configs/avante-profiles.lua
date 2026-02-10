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

  -- OpenAI GPT-5.1-Codex (coding optimized)
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

  -- NOTE: Bedrock Qwen/Mistral profiles removed - Avante only has Claude handler

  -- Bedrock DeepSeek V3 (coding model, untested)
  ["bedrock-deepseek"] = {
    provider = "bedrock-deepseek",
    mode = "legacy",
    cursor_applying_provider = "bedrock-haiku",
    auto_suggestions_provider = "bedrock-haiku",
    memory_summary_provider = "bedrock-haiku",
  },

  -- NOTE: Bedrock Llama removed - expects raw prompt format, not Messages API

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

  local Config = require("avante.config")

  -- Update config (using new API - direct property access)
  for key, value in pairs(profile) do
    Config[key] = value
  end

  vim.notify("Switched to Avante profile: " .. profile_name, vim.log.levels.INFO)
end

function M.setup()
  -- Create :AvanteProfile command
  vim.api.nvim_create_user_command("AvanteProfile", function(opts)
    if opts.args == "" then
      -- Interactive selection
      local current = require("avante.config").provider or "unknown"
      local profile_names = vim.tbl_keys(M.profiles)
      table.sort(profile_names)

      vim.ui.select(profile_names, {
        prompt = "Select Avante Profile (current: " .. current .. ")",
        format_item = function(item)
          local profile = M.profiles[item]
          return item .. " → " .. (profile.provider or "unknown")
        end,
      }, function(choice)
        if choice then
          M.switch(choice)
        end
      end)
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
