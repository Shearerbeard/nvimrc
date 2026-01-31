# Neovim Configuration Context

## Overview
NvChad-based Neovim config with extensive AI coding assistant integration.

## Avante.nvim Setup (Jan 2026)

### Provider Profiles (`:AvanteProfile <name>`)
Switch complete provider configs with delegated models for fast operations:

| Profile | Main Model | Delegated To | Type |
|---------|------------|--------------|------|
| `bedrock` | Claude Sonnet 4.5 | Haiku 4.5 | Default |
| `bedrock-opus` | Claude Opus 4.5 | Haiku 4.5 | Premium |
| `bedrock-deepseek` | DeepSeek V3.1 | Haiku 4.5 | Coding |
| `openai` | GPT-5.2 | GPT-5.1 | API |
| `openai-codex` | GPT-5.2-Codex | GPT-5.1 | Coding |
| `gemini` | Gemini 3 Pro | Flash | API |
| `bedrock-qwen` | Qwen3-Coder 480B | 30B | Open |
| `qwen-local` | Qwen3-Coder 30B | (same) | Ollama |
| `devstral-local` | Devstral 24B | (same) | Ollama |
| `acp-claude` | Claude Code CLI | - | ACP |
| `acp-opencode` | OpenCode CLI | - | ACP |
| `acp-gemini` | Gemini CLI | - | ACP |

### Delegated Provider Types
- `cursor_applying_provider` - Applying code changes to buffer
- `auto_suggestions_provider` - Tab-completion suggestions
- `memory_summary_provider` - Summarizing context for token limits

### Individual Providers (`:AvanteModels`)
All available for direct selection:
- Claude: `claude`, `claude-opus`, `claude-haiku`
- Bedrock Claude: `bedrock`, `bedrock-opus`, `bedrock-haiku`
- OpenAI: `openai`, `openai-5.1`, `openai-codex`, `copilot`
- Google: `gemini`, `gemini-flash`
- Bedrock Open: `bedrock-qwen`, `bedrock-qwen-30b`, `bedrock-deepseek`, `bedrock-deepseek-r1`, `bedrock-llama`, `bedrock-llama-scout`
- Ollama: `ollama` (Qwen3-Coder 30B), `ollama-devstral` (Devstral 24B)
- ACP: `claude-code`, `opencode`, `gemini-cli`

### Features Enabled
- Prompt logging: `~/.cache/nvim/avante_prompts/`
- Brave web search (BRAVE_API_KEY in ~/.zshenv)
- MCP Hub integration (LSP diagnostics → AI)
- ACP providers for CLI-based agentic coding

## Keybindings

### Avante (`<leader>v*`)
- `<leader>vz` - Zen mode (Claude Code-like flow)
- `<leader>va` - Ask Avante
- `<leader>vt` - Toggle sidebar
- `<leader>vm` - Switch models
- `<leader>vp` - Switch profiles

### Claude Code (`<leader>c*`)
- `<leader>cc` - Toggle Claude
- `<leader>cf` - Focus Claude
- `<leader>cr` - Resume session
- `<leader>cm` - Select model
- `<leader>cb` - Add buffer
- `<leader>cs` - Send selection (visual) / Add file (tree)
- `<leader>cy` - Accept diff
- `<leader>cn` - Deny diff

### MCP Hub
- `<leader>mh` - Open MCP Hub UI

## Shell Aliases (~/.zshenv)
- `avante` - Opens Neovim in Avante zen mode

## Files
- `lua/plugins/init.lua` - Main plugin config
- `lua/configs/avante-profiles.lua` - Profile definitions
- `lua/mappings.lua` - Keybindings

## Local Model Requirements (24GB VRAM)
- Can run one model at a time
- Recommended: `qwen3-coder:30b` or `devstral:24b`
- Pull with: `ollama pull qwen3-coder:30b`

## Dependencies Installed
- curl 8.18.0+ (Homebrew, for Bedrock AWS sig v4)
- mcp-hub (npm global via mise)
- opencode CLI (Homebrew tap)
