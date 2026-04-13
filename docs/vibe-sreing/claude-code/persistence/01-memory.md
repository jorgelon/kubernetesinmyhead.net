# Memory

Each session starts with a fresh context window. Memory is how Claude Code carries knowledge from one session to the next. There are two complementary systems:

|            | CLAUDE.md files                           | Auto memory                                                |
|------------|-------------------------------------------|------------------------------------------------------------|
| Written by | You                                       | Claude                                                     |
| Contains   | Instructions and rules                    | Learnings and patterns                                     |
| Scope      | Project, user, or org                     | Per git working tree                                       |
| Loaded     | Every session (full)                      | Every session (first 200 lines or 25KB of MEMORY.md)       |
| Use for    | Coding standards, workflows, architecture | Build commands, debugging insights, discovered preferences |

Both are loaded at the start of every conversation. Claude treats them as context, not enforced configuration. The more specific and concise the instructions, the more consistently Claude follows them.

## Auto Memory

Auto memory lets Claude accumulate knowledge across sessions without you writing anything. Claude saves notes based on corrections and interactions: build commands, debugging insights, architecture notes, preferences. Claude decides what is worth remembering — it does not save something every session.

Requires Claude Code v2.1.59+. Enabled by default. To disable:

```json
{
  "autoMemoryEnabled": false
}
```

Or via environment variable: `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`.

**Storage**: `~/.claude/projects/<project>/memory/` — git repo scoped, so all worktrees share one directory. Contains `MEMORY.md` (index, loaded each session) and topic files. Machine-local.

The 200-line / 25KB limit applies only to `MEMORY.md`. Topic files are not loaded at startup — Claude reads them on demand when needed. All files are plain markdown you can read, edit, or delete at any time.

## CLAUDE.md Files

CLAUDE.md files are markdown files you write to give Claude persistent instructions. Loaded in full at the start of every session. Ideal for explicit, stable knowledge:

- Project architecture and coding standards
- Available tools and commands
- Workflows, branching strategies, environments
- Testing instructions and code style guidelines

### Locations (most specific takes precedence)

| Scope          | Location                               | Shared with                           |
|----------------|----------------------------------------|---------------------------------------|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux)   | All users in org — cannot be excluded |
| Project        | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team via source control               |
| User           | `~/.claude/CLAUDE.md`                  | Just you, all projects                |

CLAUDE.md files in **parent directories** (up to the git root) are loaded at launch. Files in **subdirectories** load on demand when Claude reads files in those subtrees.

### `.claude/rules/`

For larger projects, split instructions into topic-specific files under `.claude/rules/`. Rules can be scoped to specific file paths with YAML frontmatter:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules
- All endpoints must include input validation
```

Rules without `paths` load at launch. Path-scoped rules only load when Claude reads matching files, saving context space.

### Imports

CLAUDE.md files can import other files with `@path/to/file` syntax:

```text
See @README for project overview.
- git workflow: @docs/git-instructions.md
```

### Tips

- Target under 200 lines per CLAUDE.md — longer files reduce adherence
- Use headers and bullets; avoid dense paragraphs
- Write verifiable instructions: `"Use 2-space indentation"` not `"Format code properly"`
- HTML block comments (`<!-- notes -->`) are stripped before injection — free notes for maintainers
- Run `/init` to auto-generate a starting CLAUDE.md from your codebase
- Run `/memory` to see all loaded CLAUDE.md files, toggle auto memory, and edit files
- Ask Claude to `"add this to CLAUDE.md"` to persist something during a session

> CLAUDE.md fully survives `/compact`. After compaction Claude re-reads and re-injects it fresh from disk.

## Links

- [Manage Claude's memory](https://code.claude.com/docs/en/memory)
