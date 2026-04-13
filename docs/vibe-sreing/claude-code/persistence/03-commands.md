# Commands (Legacy)

Commands are the original Claude Code extension mechanism. They are simple markdown files that inject a prompt into the conversation when invoked via `/namespace:name`. They have been **superseded by skills** and should not be used for new functionality.

> See [Skills](05-skills.md) for the current mechanism. See [Overview](00-overview.md) for a full comparison.

## How commands work

When you type `/namespace:name`, Claude Code reads the corresponding `.md` file and injects its content as a prompt into the current conversation context. Nothing else happens — no frontmatter is processed, no forked context is created, no model override is applied.

## File locations

Commands are resolved in this order (most specific wins):

| Scope   | Path                                       | Shared with              |
|---------|--------------------------------------------|--------------------------|
| Project | `.claude/commands/<namespace>/<name>.md`   | Team via source control  |
| User    | `~/.claude/commands/<namespace>/<name>.md` | You, across all projects |

The namespace maps to the folder name. The command name maps to the file name (without `.md`).

**Example**: `.claude/commands/git/commit.md` is invoked as `/git:commit`.

## Limitations

| Feature                    | Commands     | Skills                |
|----------------------------|--------------|-----------------------|
| Frontmatter / metadata     | No           | Yes                   |
| Auto-trigger               | No           | Yes                   |
| Model override             | No           | Yes                   |
| Forked context             | No           | Yes                   |
| Arguments                  | No           | Yes                   |
| Command palette visibility | `/name` only | `/name` + description |

## Built-in commands

Claude Code ships with built-in slash commands that are not stored in your filesystem:

| Command    | Purpose                                                  |
|------------|----------------------------------------------------------|
| `/help`    | Show available commands and keyboard shortcuts           |
| `/init`    | Generate a `CLAUDE.md` for the current project           |
| `/memory`  | View loaded memory files, toggle auto memory, edit files |
| `/agents`  | List, inspect, and manage available agents               |
| `/compact` | Compact the conversation to save context space           |
| `/clear`   | Start a fresh conversation                               |
| `/cost`    | Show token usage and cost for the current session        |
| `/fast`    | Toggle fast output mode (Opus 4 only)                    |

## Migrating to skills

Replace a command with a skill by:

1. Create `.claude/skills/<name>/SKILL.md`.
2. Add frontmatter: `name`, `description` (triggers auto-detection), and `disable-model-invocation: true` if you want manual-only invocation.
3. Move the prompt content from the old `.md` file into `SKILL.md` below the frontmatter.
4. Delete the old command file.

The slash command invocation stays the same (`/namespace:name`), but now the skill supports arguments, model overrides, and optional auto-triggering.

## Links

- [Overview — all mechanisms](00-overview.md)
- [Skills](05-skills.md)

<https://docs.anthropic.com/en/docs/claude-code/slash-commands>
