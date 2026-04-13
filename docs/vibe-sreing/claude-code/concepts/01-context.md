# Context Window

The context window holds all active information for the current session:

- Conversation history and tool outputs
- File contents read during the session
- CLAUDE.md and auto memory content
- Loaded skills and system instructions

As work progresses the context window fills up. When approaching the limit, Claude **automatically compacts**: it clears older tool outputs first, then summarizes the conversation. Key code snippets are preserved; detailed instructions from early in the conversation may be lost.

To manage this:

- Place persistent rules in CLAUDE.md — they survive compaction (re-read from disk)
- Use `/context` to see what is consuming space
- Run `/compact focus on the API changes` for targeted manual compaction
- Add custom compaction instructions in CLAUDE.md:

```markdown
# Compact instructions

When you are using compact, please focus on test output and code changes
```

**MCP tools** are deferred by default — only tool names consume context until Claude uses a specific tool. Run `/mcp` to check per-server costs.

**Skills** load on demand: Claude sees skill descriptions at session start, but full content only loads when a skill is invoked.

**Subagents** get their own fresh context window, completely separate from your main session. Their work does not bloat your context — only a summary is returned.

## Model and Context Window Size

The model determines the maximum context window available:

- **Standard (~200K tokens)**: all models (Opus 4.6, Sonnet 4.6, Haiku)
- **Extended (1M tokens)**: Opus 4.6 and Sonnet 4.6 only, via `[1m]` suffix:

```bash
/model opus[1m]
/model sonnet[1m]
```

On Max, Team, and Enterprise plans, Opus is automatically upgraded to 1M with no extra configuration. On other plans, extra usage applies. `opusplan` uses Sonnet's window during execution — use `opus[1m]` explicitly for 1M throughout. Disable extended context with `CLAUDE_CODE_DISABLE_1M_CONTEXT=1`.

## Other Ways to Add Context Within a Session

- The current selection or open tab in the IDE is automatically shared with Claude Code
- Diagnostic errors (lint, syntax, etc.) from the IDE are automatically shared as you work

## Links

- [Explore the context window](https://code.claude.com/docs/en/context-window)
- [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works)
