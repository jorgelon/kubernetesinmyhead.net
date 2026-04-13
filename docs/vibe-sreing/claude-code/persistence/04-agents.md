# Agents

Agents (subagents) are specialized AI assistants that run as isolated background workers. The orchestrator spawns them automatically by matching the task context against each agent's description. Manage them with the `/agents` command.

> See [Overview](00-overview.md) for a full comparison with other mechanisms.

## How agents work

The orchestrator (main Claude instance) reads all agent `description` fields and uses them to decide whether to delegate a subtask via the `Task` tool. When it does:

1. A new Claude instance starts with the agent's instructions as its system prompt.
2. It runs in a **forked context** — completely isolated from the main conversation.
3. It has its own tool access, model configuration, and context window.
4. Results are returned to the orchestrator as a single message.

The agent never shares state with the main conversation mid-run. The main conversation stays clean.

## Frontmatter reference

```markdown
---
name: my-agent
description: >
  Triggered when the user asks to validate or lint markdown files.
  Use this agent to check formatting, headings, and line lengths.
model: haiku
tools:
  - Read
  - Glob
  - Bash
---

Agent instructions here...
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Identifier used by the Task tool when spawning |
| `description` | Yes | Natural language description — the orchestrator uses this to decide when to spawn |
| `model` | No | Override the model: `haiku`, `sonnet`, `opus` |
| `tools` | No | Restrict which tools the agent can use |

## File locations

| Scope | Path |
|-------|------|
| Project | `.claude/agents/<name>.md` |
| User | `~/.claude/agents/<name>.md` |

Project agents take precedence over user agents with the same name.

## Key characteristics

- **Always forked**: Agents never run inline. Each invocation gets a fresh context.
- **No direct invocation**: You cannot call an agent with `/name`. The orchestrator decides.
- **No arguments**: Agents receive the delegated task description, not user-typed arguments.
- **Model override**: Running heavy reasoning agents on `opus` and lightweight ones on `haiku` is a valid cost optimization.
- **Tool restriction**: Limit an agent's `tools` list to reduce blast radius for sensitive operations.

## Managing agents

The `/agents` built-in command lists all available agents (built-in + project + user), shows their descriptions, and lets you inspect or disable them.

## Coexistence with skills

A common pattern: create both an agent and a skill for the same functionality.

| Piece | Role |
|-------|------|
| Agent | Runs automatically when the orchestrator decides it's relevant |
| Skill | Provides a `/command` entry point for manual invocation |

Both can point to the same prompt content and share the same model configuration. The agent handles "proactive" and the skill handles "on demand".

## When to use agents

- You want something to happen **without being asked** — e.g., always validate output after writing files.
- The behavior should be **background / isolated** — it does not need access to the current conversation.
- You want a **cost-optimized model** for a specific routine task.

## Links

- [Overview — all mechanisms](00-overview.md)
- [Skills](05-skills.md)
- [Tools](../concepts/04-tools.md) — agents run with their own isolated tool access

<https://docs.anthropic.com/en/docs/claude-code/sub-agents>
