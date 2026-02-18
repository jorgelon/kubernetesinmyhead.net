# Files

## Scopes

Claude Code uses four scope tiers that determine where config applies and who it is shared with.

| Scope       | Location                                       | Who it affects           | Shared?                |
|-------------|------------------------------------------------|--------------------------|------------------------|
| **Managed** | System dirs (`/etc/claude-code/` on Linux/WSL) | All users on the machine | IT-deployed            |
| **User**    | `~/.claude/`                                   | You, all projects        | No                     |
| **Project** | `.claude/` in repo                             | All collaborators        | Yes (committed to git) |
| **Local**   | `.claude/*.local.*` in repo                    | You, this repo only      | No (auto-gitignored)   |

### Managed

Organization-wide enforcement by IT/DevOps. Highest precedence — cannot be overridden. Used for security policies, compliance, and model restrictions.

- Linux/WSL: `/etc/claude-code/`
- macOS: `/Library/Application Support/ClaudeCode/`

### User

Personal preferences applied across all projects. Not shared with anyone. Best for personal tools, themes, and API configuration.

### Project

Committed to source control and shared with all collaborators. Best for team permissions, hooks, and shared tooling.

### Local

Personal machine-specific overrides within a project. Automatically gitignored. Good for testing configurations or machine-specific settings before sharing with the team.

## Files by Scope

### Settings

| File                                     | Scope   |
|------------------------------------------|---------|
| `/etc/claude-code/managed-settings.json` | Managed |
| `~/.claude/settings.json`                | User    |
| `.claude/settings.json`                  | Project |
| `.claude/settings.local.json`            | Local   |

### Memory / Instructions (CLAUDE.md)

| File                               | Scope   |
|------------------------------------|---------|
| `~/.claude/CLAUDE.md`              | User    |
| `CLAUDE.md` or `.claude/CLAUDE.md` | Project |
| `.claude/CLAUDE.local.md`          | Local   |

Loaded at startup to provide custom instructions and context.

### MCP Servers

| File                                | Scope                                                    |
|-------------------------------------|----------------------------------------------------------|
| `~/.claude.json`                    | User (also stores OAuth, preferences, per-project state) |
| `.mcp.json`                         | Project                                                  |
| `/etc/claude-code/managed-mcp.json` | Managed                                                  |

### Subagents

| Path                | Scope   |
|---------------------|---------|
| `~/.claude/agents/` | User    |
| `.claude/agents/`   | Project |

Markdown files with YAML frontmatter defining specialized agents.

## Precedence (highest to lowest)

1. Managed — cannot be overridden
2. Command line arguments
3. Local (`.claude/settings.local.json`)
4. Project (`.claude/settings.json`)
5. User (`~/.claude/settings.json`)

Settings are merged across scopes, not replaced. Lower-precedence values still apply for settings not overridden at a higher scope.

## Key Settings Fields

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "model": "opus",
  "effortLevel": "high",
  "availableModels": ["sonnet", "haiku"],
  "permissions": {
    "allow": ["Bash(npm run lint)", "Read(~/.zshrc)"],
    "deny": ["Bash(curl *)", "Read(./.env)"],
    "ask": ["Bash(git push *)"],
    "additionalDirectories": ["../docs/"],
    "defaultMode": "acceptEdits"
  },
  "env": {
    "MY_VAR": "value"
  },
  "hooks": {},
  "cleanupPeriodDays": 30,
  "language": "english",
  "statusLine": {"type": "command", "command": "~/.claude/statusline.sh"},
  "sandbox": {
    "enabled": true,
    "network": {
      "allowedDomains": ["github.com"]
    }
  }
}
```

### Permissions evaluation order

`deny` → `ask` → `allow` (first match wins)

## Backups

Claude Code automatically creates timestamped backups of configuration files, retaining the 5 most recent.

## Links

- [Settings reference](https://code.claude.com/docs/en/settings)
- [Memory files (CLAUDE.md)](https://code.claude.com/docs/en/memory)
- [Subagents](https://code.claude.com/docs/en/sub-agents)
- [MCP servers](https://code.claude.com/docs/en/mcp)
