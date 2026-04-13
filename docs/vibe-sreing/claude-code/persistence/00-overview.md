# Behavior Configuration Overview

Claude Code extends and persists behavior through five mechanisms. Choose by *who triggers it* and *what it produces*.

## Comparison

| Mechanism                  | Written by   | Trigger                           | Runs as          | Typical use                                   |
|----------------------------|--------------|-----------------------------------|------------------|-----------------------------------------------|
| [Memory](01-memory.md)     | You + Claude | Session start (automatic)         | Injected context | Instructions, standards, persistent learnings |
| [Hooks](02-hooks.md)       | You          | Tool lifecycle event              | Shell command    | Validation, audit logging, permission guards  |
| [Commands](03-commands.md) | You          | `/namespace:name` (manual only)   | Inline prompt    | Legacy slash commands — **deprecated**        |
| [Agents](04-agents.md)     | You          | Automatic (orchestrator match)    | Forked subagent  | Proactive always-on behaviors                 |
| [Skills](05-skills.md)     | You          | `/namespace:name` or auto-trigger | Inline or forked | Structured workflows, modern slash commands   |

## When to use what

- **Memory** — Stable facts Claude must always know: architecture, coding standards, workflows, build commands.
- **Hooks** — Side-effects that must happen regardless of what Claude decides: lint on save, audit trail, permission enforcement.
- **Commands** — You have a legacy `.claude/commands/` file. Migrate to a skill.
- **Agents** — Something should run *automatically* without being invoked (e.g., validate every markdown file after edits).
- **Skills** — You want a `/command` to invoke manually, or you need both auto-trigger and manual invocation with arguments.

## Quick decision guide

```text
Need Claude to always follow a rule?          → Memory (CLAUDE.md)
Need a shell side-effect on every tool use?   → Hook
Want a manual slash command with rich logic?  → Skill (disable-model-invocation: true)
Want something proactive, no invoke needed?   → Agent
Need both proactive + manual entry point?     → Agent + Skill sharing the same prompt
Have an old command file?                     → Migrate to Skill
```

## Scopes and precedence

Configuration is applied across four tiers. Higher tiers override lower ones. Settings are **merged** (not replaced) — lower-tier values still apply for keys not set at a higher tier.

| Scope       | Location                        | Affects              | Shared?                |
|-------------|---------------------------------|----------------------|------------------------|
| **Managed** | `/etc/claude-code/` (Linux/WSL) | All users on machine | IT-deployed, enforced  |
| **User**    | `~/.claude/`                    | You, all projects    | No                     |
| **Project** | `.claude/` in repo              | All collaborators    | Yes (committed to git) |
| **Local**   | `.claude/*.local.*` in repo     | You, this repo only  | No (auto-gitignored)   |

Precedence (highest to lowest): Managed → CLI args → Local → Project → User.

## Storage locations

Mechanism files by scope:

| File                                     | Scope   | Purpose                               |
|------------------------------------------|---------|---------------------------------------|
| `/etc/claude-code/managed-settings.json` | Managed | Org-wide settings                     |
| `~/.claude/settings.json`                | User    | Personal preferences                  |
| `.claude/settings.json`                  | Project | Team permissions and hooks            |
| `.claude/settings.local.json`            | Local   | Machine-specific overrides            |
| `~/.claude/CLAUDE.md`                    | User    | Personal instructions (all projects)  |
| `CLAUDE.md` / `.claude/CLAUDE.md`        | Project | Team instructions                     |
| `.claude/CLAUDE.local.md`                | Local   | Private project notes                 |
| `~/.claude/agents/`                      | User    | Personal agents                       |
| `.claude/agents/`                        | Project | Team agents                           |
| `~/.claude.json`                         | User    | OAuth, preferences, per-project state |
| `.mcp.json`                              | Project | MCP server definitions                |

## Links

- [Memory](01-memory.md)
- [Hooks](02-hooks.md)
- [Commands](03-commands.md)
- [Agents](04-agents.md)
- [Skills](05-skills.md)
