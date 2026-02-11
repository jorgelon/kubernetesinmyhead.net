# Commands, Agents and Skills

Claude Code provides three mechanisms to extend its behavior: commands, agents, and skills. They serve different purposes and have different invocation models.

## Quick comparison

| Aspect         | Commands                 | Agents                     | Skills                         |
|----------------|--------------------------|----------------------------|--------------------------------|
| Location       | `.claude/commands/`      | `.claude/agents/`          | `.claude/skills/`              |
| File format    | `<namespace>/<name>.md`  | `<name>.md`                | `<name>/SKILL.md`              |
| Invocation     | `/namespace:name` (user) | Automatic via Task tool    | `/namespace:name` or automatic |
| Execution      | Inline prompt injection  | Forked subagent            | Inline or forked context       |
| Metadata       | None                     | Frontmatter                | Frontmatter                    |
| Auto-trigger   | No                       | Yes (based on description) | Conditional                    |
| Model override | No                       | Yes                        | Yes                            |
| Status         | **Deprecated**           | Active                     | Active                         |

## Commands (legacy)

Commands are the original extension mechanism. Simple markdown files that inject a prompt when invoked via `/namespace:name`. They live under `.claude/commands/<namespace>/<name>.md` and can be defined per user (`~/.claude/commands/`) or per project (`.claude/commands/`).

- No frontmatter or metadata support
- Always run inline in the current conversation context
- Cannot be auto-triggered
- Superseded by skills

> Claude Code includes some built-in commands

## Agents

Agents (subagents) are specialized AI assistants that run as background workers via the `Task` tool. They are spawned automatically by the orchestrator based on pattern matching against their description. Manage them with the `/agents` command.

- `name`: Identifier used when spawning via Task tool
- `description`: Determines when the orchestrator auto-spawns the agent
- `model`: Override which model runs the agent (haiku, sonnet, opus)

> The task tool runs a sub-agent to handle complex, multi-step tasks and delegate work

### Agent key characteristics

- Always run in a forked context (separate from main conversation)
- Triggered automatically based on description matching
- Cannot be invoked directly via slash command
- Useful for proactive, always-on behaviors (e.g., lint every markdown file)
- Each agent gets its own fresh context, keeping the main conversation clean

## Skills

Skills are the current extension format, replacing commands with richer capabilities. They combine slash command invocation with optional auto-triggering and metadata. Each skill requires a `SKILL.md` file with a name (64 char max) and description (1024 char max).

### Skill architecture - three content levels

1. **Metadata** (always loaded, ~100 tokens): Lightweight description of purpose and trigger conditions
2. **Instructions** (loaded when triggered, <5,000 tokens): Procedural knowledge and step-by-step workflows
3. **Resources and code** (loaded as needed): Optional scripts and reference materials executed via bash

### Skill frontmatter options

- `name`: Slash command name (format `namespace:command`)
- `description`: Purpose and auto-trigger conditions
- `disable-model-invocation`: When `true`, only manual `/name` invocation works
- `context`: `fork` runs in separate context, omit for inline
- `model`: Override model for this skill
- `argument-hint`: Shows usage hint in command palette

### Skill key characteristics

- Invokable via `/namespace:name` like legacy commands
- Support auto-triggering (unless `disable-model-invocation: true`)
- Can run inline or forked depending on `context` setting
- Support arguments and model overrides
- Can include resource files alongside `SKILL.md`
- Available in Claude Code, Claude API, and Claude.ai (with limitations)
- No network access by default, sandboxed execution

## When to use what

| Use case                                  | Mechanism                                    |
|-------------------------------------------|----------------------------------------------|
| Proactive background behavior (always-on) | Agent                                        |
| User-invoked workflow with `/command`     | Skill                                        |
| Auto-triggered + manually invokable       | Skill with `disable-model-invocation: false` |
| Strictly manual invocation only           | Skill with `disable-model-invocation: true`  |
| Legacy compatibility                      | Command (migrate to skill)                   |

## Choosing between agent and skill

The decision comes down to how the functionality gets triggered:

- **Agent**: When you want something that runs automatically without you asking. The orchestrator reads the description and spawns it whenever the situation matches.
- **Skill**: When you want something you invoke explicitly with `/name`, or when you need arguments, context mode control, or command palette visibility.

|                            | Agent                            | Skill                              |
|----------------------------|----------------------------------|------------------------------------|
| Runs in                    | Always forked (isolated context) | Inline or forked (`context: fork`) |
| Accepts arguments          | No                               | Yes (`argument-hint`)              |
| User can invoke directly   | No                               | Yes (`/name`)                      |
| Appears in command palette | No                               | Yes                                |

**Rule of thumb**:

- If you would forget to invoke it manually, make it an agent
- If you want to control when it runs, make it a skill with `disable-model-invocation: true`
- If you need both, create both pointing to the same logic

### Coexistence

Agents and skills can coexist for the same functionality. A common pattern is:

- **Agent** handles automatic triggering (orchestrator spawns it via Task tool)
- **Skill** provides the `/command` entry point for manual invocation

Both can share the same prompt content and model configuration.

## Links

- Slash commands

<https://docs.anthropic.com/en/docs/claude-code/slash-commands>

- Agent skills overview

<https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview>

- Equipping agents for the real world with Agent Skills

<https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills>
