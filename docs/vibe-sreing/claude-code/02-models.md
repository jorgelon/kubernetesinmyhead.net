# Models

Claude Code supports model selection via aliases or full model names.

## Model Aliases

| Alias | Behavior |
|-------|----------|
| `default` | Recommended model for your account type |
| `sonnet` | Latest Sonnet (currently 4.6) for daily coding tasks |
| `opus` | Latest Opus (currently 4.6) for complex reasoning |
| `haiku` | Fast and efficient for simple tasks |
| `sonnet[1m]` | Sonnet with 1M token context window |
| `opusplan` | Opus during plan mode, Sonnet for execution |

Aliases always point to the latest version. To pin to a specific version, use the full model name (e.g., `claude-opus-4-6`).

## Switching Models

Four ways to set the model, in order of priority:

1. **During session**: `/model <alias|name>`
2. **At startup**: `claude --model <alias|name>`
3. **Environment variable**: `ANTHROPIC_MODEL=<alias|name>`
4. **Settings file**: `"model": "opus"` in `~/.claude/settings.json`

## Default Model by Subscription

| User type | Default model |
|-----------|---------------|
| Max, Team Premium, Pro | Opus 4.6 |
| Pay-as-you-go (API) | Sonnet 4.5 |

Claude Code may automatically fall back to Sonnet if you hit a usage threshold with Opus.

## opusplan

Uses Opus during plan mode for complex reasoning, then switches to Sonnet for code execution. Best of both worlds: reasoning quality + execution efficiency.

## Effort Level (Opus 4.6)

Controls adaptive reasoning depth. Three levels: **low**, **medium**, **high** (default).

- **In `/model`**: use arrow keys on the effort slider
- **Environment variable**: `CLAUDE_CODE_EFFORT_LEVEL=low|medium|high`
- **Settings file**: `"effortLevel": "high"`

## Extended Context (1M tokens)

Use the `[1m]` suffix for long sessions:

```bash
/model sonnet[1m]
/model claude-sonnet-4-6[1m]
```

> Opus 4.6 1M context is only for API and pay-as-you-go users. Not available for Pro/Max/Teams/Enterprise subscribers.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_MODEL` | Override model selection |
| `CLAUDE_CODE_EFFORT_LEVEL` | Effort level: `low`, `medium`, or `high` |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Full model name for the `opus` alias |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Full model name for the `sonnet` alias |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Full model name for the `haiku` alias and background tasks |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model for subagents |

> `ANTHROPIC_SMALL_FAST_MODEL` is deprecated in favor of `ANTHROPIC_DEFAULT_HAIKU_MODEL`.

## Prompt Caching

Enabled by default to reduce costs. Disable globally or per model tier:

| Variable | Description |
|----------|-------------|
| `DISABLE_PROMPT_CACHING` | Set to `1` to disable for all models |
| `DISABLE_PROMPT_CACHING_HAIKU` | Set to `1` to disable for Haiku only |
| `DISABLE_PROMPT_CACHING_SONNET` | Set to `1` to disable for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Set to `1` to disable for Opus only |

## Enterprise Model Restrictions

Admins can restrict available models via `availableModels` in managed settings. The `model` field sets the explicit override:

```json
{
  "availableModels": ["sonnet", "haiku"],
  "model": "sonnet"
}
```

## Links

- [Model configuration](https://code.claude.com/docs/en/model-config)
- [Models overview](https://docs.anthropic.com/en/docs/about-claude/models/overview)
- [Choosing the right model](https://docs.anthropic.com/en/docs/about-claude/models/choosing-a-model)
- [Claude Code model configuration (support article)](https://support.claude.com/en/articles/11940350-claude-code-model-configuration)
