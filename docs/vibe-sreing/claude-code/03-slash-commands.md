# Available commands

## Slash commands

Slash commands are a powerful feature that allows you to control Claude's behavior during an interactive session. They serve as quick, flexible shortcuts for various actions and workflows.

**Key Features:**

- **Built-in commands**: Like `/clear`, `/help`, `/model` for core functionality
- **Custom commands**: User-defined, project-specific, or personal commands
- **MCP commands**: Commands provided by Model Context Protocol servers
- **Customization**: Support arguments, file references, bash command execution, and frontmatter configuration
- **Flexibility**: Can be simple single-line prompts or complex multi-step workflows

Slash commands provide a streamlined, programmable interface to enhance productivity and interaction with Claude. They're easily shareable across projects and teams.

## Builtin commands

### Context Management

| Command               | Description                                                                                                      |
|-----------------------|------------------------------------------------------------------------------------------------------------------|
| `/add-dir`            | Add additional working directories to your project context                                                       |
| `/clear` (reset, new) | Clear the entire conversation history and free up context                                                        |
| `/compact`            | Condense conversation history keeping only a summary. Optional: `/compact [instructions]` for focused summary    |
| `/context`            | Visualize current context usage as a colored grid showing token distribution                                     |
| `/init`               | Initialize project with a CLAUDE.md guide file containing codebase documentation                                 |
| `/memory`             | Edit CLAUDE.md memory files (user and project-specific)                                                          |

### Conversation

| Command                | Description                                                                           |
|------------------------|---------------------------------------------------------------------------------------|
| `/bashes`              | List and manage background bash processes and tasks                                   |
| `/export`              | Export the current conversation to a file or clipboard                                |
| `/resume`              | Resume a previous conversation session                                                |
| `/rewind` (checkpoint) | Rewind the conversation and/or code to a previous checkpoint or state                 |
| `/todos`               | List current todo items and task tracking status                                      |

### Configuration

| Command                        | Description                                                                             |
|--------------------------------|-----------------------------------------------------------------------------------------|
| `/agents`                      | Manage custom AI subagent configurations for specialized tasks                          |
| `/config` (theme)              | Open Settings interface (Config tab) for configuration management                       |
| `/hooks`                       | Manage hook configurations for tool events and command execution                        |
| `/ide`                         | Manage IDE integrations and show connection status                                      |
| `/mcp`                         | Manage MCP server connections and OAuth authentication                                  |
| `/migrate-installer`           | Migrate from global npm installation to local installation                              |
| `/model`                       | Select or change the AI model being used                                                |
| `/output-style`                | Set the output style directly or select from a menu                                     |
| `/output-style:new`            | Create a new custom output style                                                        |
| `/permissions` (allowed-tools) | View and update allow & deny tool permission rules                                      |
| `/statusline`                  | Set up and configure Claude Code's status line UI                                       |
| `/terminal-setup`              | Install Shift+Enter key binding for newlines (iTerm2 and VSCode)                        |
| `/upgrade`                     | Upgrade to Max plan for higher rate limits and more Opus access                         |
| `/vim`                         | Toggle between Vim mode (insert/command) and Normal editing modes                       |

### Status Commands

| Command   | Description                                                                                           |
|-----------|-------------------------------------------------------------------------------------------------------|
| `/cost`   | Show token usage statistics and subscription-specific cost details for the current session            |
| `/doctor` | Check the health of your Claude Code installation and verify settings                                 |
| `/status` | Open Settings (Status tab) showing version, model, account, API connectivity, and tool statuses       |
| `/usage`  | Show plan usage limits and rate limit status for your subscription                                    |

### Git Related

| Command               | Description                                                                            |
|-----------------------|----------------------------------------------------------------------------------------|
| `/install-github-app` | Set up Claude GitHub Actions integration for a repository                              |
| `/pr-comments`        | View and retrieve comments from a GitHub pull request                                  |
| `/review`             | Request a code review for a pull request                                               |
| `/security-review`    | Perform a comprehensive security review of pending changes on the current branch       |

### Misc

| Command             | Description                                                               |
|---------------------|---------------------------------------------------------------------------|
| `/exit` (quit)      | Exit the Claude Code REPL                                                 |
| `/feedback` (bug)   | Report bugs or submit feedback about Claude Code (sends to Anthropic)     |
| `/help`             | Show usage help and list all available commands                           |
| `/login`            | Sign in or switch between Anthropic accounts                              |
| `/logout`           | Sign out from your current Anthropic account                              |
| `/privacy-settings` | View and update your privacy settings and data sharing preferences        |
| `/release-notes`    | View release notes for Claude Code updates                                |

## Custom slash commands

It possible to define custom slash commands via md files

- Per user

```txt
~/.claude/commands/

```

- Per project

```txt
.claude/commands/
```

## Links

- Slash commands

<https://docs.anthropic.com/en/docs/claude-code/slash-commands>
