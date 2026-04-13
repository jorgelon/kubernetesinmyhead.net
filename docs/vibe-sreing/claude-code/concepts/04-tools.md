# Tools

Tools are what make Claude Code agentic. Without tools, Claude can only respond with text. With tools, Claude can act: read code, edit files, run commands, search the web, and interact with external services.

Each tool use returns information that feeds back into the agentic loop, informing Claude's next decision.

## The agentic loop

When you give Claude a task, it works through three phases: **gather context**, **take action**, and **verify results**. Claude uses tools throughout all phases, chaining dozens of actions together and course-correcting along the way. For example, when asked to "fix the failing tests":

1. **Bash** — Run the test suite to see failures
2. **Read** — Read the error output and relevant source files
3. **Edit** — Fix the code
4. **Bash** — Run tests again to verify

You can interrupt at any point to steer Claude in a different direction.

## Built-in tools

### File operations

| Tool             | Description                      | Permission |
|------------------|----------------------------------|------------|
| **Read**         | Read file contents               | No         |
| **Edit**         | Targeted edits to specific files | Yes        |
| **Write**        | Create or overwrite files        | Yes        |
| **NotebookEdit** | Edit Jupyter notebook cells      | Yes        |

### Search

| Tool     | Description                                        | Permission |
|----------|----------------------------------------------------|------------|
| **Glob** | Find files by pattern matching (e.g., `**/*.yaml`) | No         |
| **Grep** | Search file contents with regex                    | No         |

### Execution

| Tool     | Description                                | Permission |
|----------|--------------------------------------------|------------|
| **Bash** | Execute shell commands in your environment | Yes        |

### Web

| Tool          | Description                          | Permission |
|---------------|--------------------------------------|------------|
| **WebSearch** | Search the web for information       | No         |
| **WebFetch**  | Fetch and process content from a URL | No         |

### Orchestration

| Tool                | Description                           | Permission |
|---------------------|---------------------------------------|------------|
| **Task**            | Spawn subagents for delegated work    | No         |
| **TaskOutput**      | Retrieve output from background tasks | No         |
| **AskUserQuestion** | Ask the user for clarification        | No         |
| **ExitPlanMode**    | Exit plan mode and start implementing | Yes        |

## Extending tools

The built-in tools are the foundation. Claude Code can be extended with additional tools through:

- **MCP servers**: Connect external services (databases, APIs, custom tools) via the Model Context Protocol. See [MCP servers](03-mcp-servers.md)
- **Skills**: Domain-specific workflows that orchestrate tool usage. See [Skills](../persistence/05-skills.md)
- **Subagents**: Delegated workers with their own tool access and context. See [Agents](../persistence/04-agents.md)
- **Hooks**: Shell commands that run automatically on tool events. See [Hooks](../persistence/02-hooks.md)

## Permissions

Tools that modify state (Edit, Write, Bash) require permission. Claude asks before using them unless you pre-approve in `settings.json`.

### Permission modes

Cycle through modes with `Shift+Tab`:

- **Default**: Claude asks before file edits and shell commands
- **Auto-accept edits**: Claude edits files without asking, still asks for commands
- **Plan mode**: Read-only tools only, creates a plan for approval

### Permission rules in settings

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash(npm run lint)", "Read(~/.zshrc)"],
    "deny": ["Bash(curl *)", "Read(./.env)"],
    "ask": ["Bash(git push *)"],
    "additionalDirectories": ["../docs/"],
    "defaultMode": "acceptEdits"
  },
  "env": { "MY_VAR": "value" },
  "hooks": {},
  "cleanupPeriodDays": 30,
  "language": "english"
}
```

Evaluation order: `deny` → `ask` → `allow` (first match wins). Rules support glob patterns for command arguments.

Claude Code automatically creates timestamped backups of config files, retaining the 5 most recent.

## Links

- [Hooks](../persistence/02-hooks.md) — shell scripts that intercept tool lifecycle events
- [Agents](../persistence/04-agents.md) — subagents get their own isolated tool access and context
- [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works)
- [Settings and permissions](https://code.claude.com/docs/en/settings)
