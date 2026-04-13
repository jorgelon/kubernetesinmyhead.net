# Skills

Skills are the current extension format for Claude Code, replacing legacy commands with richer capabilities. They combine slash command invocation with optional auto-triggering, model overrides, and structured content levels.

> See [Overview](00-overview.md) for a full comparison with other mechanisms.

## Three content levels

Skills are designed to be token-efficient. Content is loaded progressively:

| Level | When loaded | Size limit | Purpose |
|-------|------------|-----------|---------|
| **Metadata** | Always (every session) | ~100 tokens | Name, description, trigger conditions |
| **Instructions** | When the skill is triggered | < 5,000 tokens | Step-by-step workflow and procedural knowledge |
| **Resources** | On demand, inside the skill | Unlimited | Scripts, reference files, templates |

Only the metadata is loaded at startup. Instructions load when the skill fires. Resources are fetched only if the skill's instructions reference them.

## File structure

```text
.claude/skills/
└── <name>/
    ├── SKILL.md          # Required — metadata + instructions
    ├── script.sh         # Optional resource files
    └── template.yaml     # Optional reference materials
```

Each skill lives in its own subdirectory. The `SKILL.md` file is required; additional files in the directory are resources the skill can reference.

## Frontmatter reference

```markdown
---
name: ns:my-skill
description: >
  Invoked when the user asks to review changed code for quality issues.
  Also triggers when a PR review is mentioned.
context: fork
model: sonnet
argument-hint: "[file-path]"
disable-model-invocation: false
---

Skill instructions here...
```

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Slash command name. Format: `namespace:command` (max 64 chars) |
| `description` | Yes | Purpose + auto-trigger conditions (max 1024 chars) |
| `context` | No | `fork` runs in isolated subagent. Omit for inline (default) |
| `model` | No | Override model: `haiku`, `sonnet`, `opus` |
| `argument-hint` | No | Usage hint shown in command palette (e.g., `[file-path]`) |
| `disable-model-invocation` | No | `true` = manual `/name` only, no auto-trigger (default: `false`) |

## Invocation matrix

| Mode | How to configure | When it triggers |
|------|-----------------|-----------------|
| Manual only | `disable-model-invocation: true` | Only when you type `/ns:name` |
| Auto only | `disable-model-invocation: false`, no slash needed | Orchestrator decides from description |
| Both | `disable-model-invocation: false` (default) | `/ns:name` or auto-triggered |

## Inline vs forked execution

| Setting | Behavior |
|---------|----------|
| No `context` field | Runs inline — shares the main conversation context |
| `context: fork` | Runs as a subagent — isolated context, same as agents |

Use `context: fork` when the skill does heavy work you want isolated (long output, scratch space, different model). Use inline when the skill needs to read or update the current conversation state.

## Skill vs Agent

| | Agent | Skill |
|-|-------|-------|
| Manual invocation | No | Yes (`/ns:name`) |
| Auto-trigger | Yes (always) | Yes (when `disable-model-invocation: false`) |
| Accepts arguments | No | Yes (`argument-hint`) |
| Appears in command palette | No | Yes |
| Context | Always forked | Inline or forked |

**Rule of thumb**: if you would forget to invoke it, use an agent. If you need control over when it runs, use a skill. If you need both, create both pointing to the same logic.

## Availability

| Platform | Support |
|----------|---------|
| Claude Code CLI | Full |
| Claude API | Full |
| Claude.ai | Partial (no resource files, no forked context) |

Skills have no network access by default and run in a sandboxed environment.

## Links

- [Overview — all mechanisms](00-overview.md)
- [Agents](04-agents.md)

<https://docs.anthropic.com/en/docs/agents-and-tools/agent-skills/overview>

<https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills>
