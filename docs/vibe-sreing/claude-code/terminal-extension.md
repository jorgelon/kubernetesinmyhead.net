# Terminal - VSCODE extension comparison

This document lists the available features using claude code in a linux terminal and via vscode extension.

> It can change in newer versions

## How to open claude code

We can open claude code two ways

### In a linux terminal or vscode terminal

Simply write

```shell
claude
```

Same as CTRL+P and Claude Code: Open in terminal

## In a vscode extension tab

- Via `Ctrl+Esc` shortcut
- Also click the Claude Code icon
- Also CTRL+P and Claude Code: Open in new tab

## Slash Commands table

| Features            | terminal | vscode extension | Description                                                                                    |
|---------------------|----------|------------------|------------------------------------------------------------------------------------------------|
| /                   | ✅        | ✅                | Show all available features                                                                    |
| /add-dir            | ✅        | ❌                | Add a new working directory                                                                    |
| /agents             | ✅        | ❌                | Manage agent configurations                                                                    |
| /bashes             | ✅        | ❌                | List and manage background tasks                                                               |
| /clear              | ✅        | ✅                | Clear conversation history and free up context                                                 |
| /command            | ✅        | ✅                | Execute a command                                                                              |
| /compact            | ✅        | ✅                | Clear conversation history but keep a summary in context                                       |
| /config             | ✅        | ❌                | Open config panel                                                                              |
| /context            | ✅        | ✅                | Visualize current context usage as a colored grid                                              |
| /cost               | ✅        | ✅                | Show the total cost and duration of the current session                                        |
| /doctor             | ✅        | ❌                | Diagnose and verify your Claude Code installation and settings                                 |
| /exit               | ✅        | ❌                | Exit the REPL                                                                                  |
| /export             | ✅        | ❌                | Export the current conversation to a file or clipboard                                         |
| /feedback           | ✅        | ❌                | Submit feedback about Claude Code                                                              |
| /help               | ✅        | ❌                | Show help and available commands                                                               |
| /hooks              | ✅        | ❌                | Manage hook configurations for tool events                                                     |
| /ide                | ✅        | ❌                | Manage IDE integrations and show status                                                        |
| /init               | ✅        | ✅                | Initialize a new CLAUDE.md file with codebase documentation                                    |
| /install-github-app | ✅        | ❌                | Set up Claude GitHub Actions for a repository                                                  |
| /login              | ✅        | ✅                | Sign in with your Anthropic account                                                            |
| /logout             | ✅        | ❌                | Sign out from your Anthropic account                                                           |
| /mcp                | ✅        | ✅                | Manage MCP servers                                                                             |
| /migrate-installer  | ✅        | ❌                | Migrate from global npm installation to local installation                                     |
| /model              | ✅        | ✅                | Set the AI model for Claude Code                                                               |
| /output-style       | ✅        | ❌                | Set the output style directly or from a selection menu                                         |
| /output-style:new   | ✅        | ✅                | Create a custom output style                                                                   |
| /permissions        | ✅        | ❌                | Manage allow & deny tool permission rules                                                      |
| /pr-comments        | ✅        | ✅                | Get comments from a GitHub pull request                                                        |
| /privacy-settings   | ✅        | ❌                | View and update your privacy settings                                                          |
| /release-notes      | ✅        | ✅                | View release notes                                                                             |
| /resume             | ✅        | ✅                | Resume a conversation                                                                          |
| /review             | ✅        | ✅                | Review a pull request                                                                          |
| /security-review    | ✅        | ✅                | Complete a security review of the pending changes on the current branch                        |
| /status             | ✅        | ❌                | Show Claude Code status including version, model, account, API connectivity, and tool statuses |
| /statusline         | ✅        | ❌                | Set up Claude Code's status line UI                                                            |
| /terminal-setup     | ✅        | ❌                | Install Shift+Enter key binding for newlines                                                   |
| /todos              | ✅        | ✅                | List current todo items                                                                        |
| /upgrade            | ✅        | ❌                | Upgrade to Max for higher rate limits and more Opus                                            |
| /usage              | ✅        | ❌                | Check plan usage limits                                                                        |
| /vim                | ✅        | ❌                | Toggle between Vim and Normal editing modes                                                    |

## Keyboard shortcuts

| Shortcuts      | terminal | vscode extension | Description                                                                  |
|----------------|----------|------------------|------------------------------------------------------------------------------|
| !              | ✅        | ❌                | Shortcut to run bash commands directly                                       |
| #              | ✅        | ❌                | Shortcut to add to memory                                                    |
| @              | ✅        | ✅                | Mention a file                                                               |
| \ + ENTER      | ✅        | ❌                | Multiline input (quick escape, all terminals)                                |
| ALT+CTRL+K     | ✅        | ❌                | Mention a focused file                                                       |
| Attach a file  | ❌        | ✅                |                                                                              |
| CTRL+B         | ✅        | ❌                | Move bash command to background                                              |
| CTRL+C         | ✅        | ❌                | Cancel current input or generation                                           |
| CTRL+D         | ✅        | ❌                | Exit Claude Code session                                                     |
| CTRL+J         | ✅        | ❌                | Line feed character (multiline input)                                        |
| CTRL+L         | ✅        | ❌                | Clear terminal screen                                                        |
| CTRL+R         | ✅        | ❌                | Reverse search command history                                               |
| ESC + ESC      | ✅        | ❌                | Rewind code/conversation                                                     |
| SHIFT+ENTER    | ✅        | ❌                | Multiline input (after /terminal-setup)                                      |
| SHIFT+TAB      | ✅        | ❌                | Cycle through modes: Default → Auto-Accept (⏵⏵) → Plan Mode (⏸) → Default... |
| TAB            | ✅        | ❌                | Toggle extended thinking                                                     |
| Up/Down arrows | ✅        | ❌                | Navigate command history                                                     |

## Links

- Optimize your terminal setup

<https://docs.claude.com/en/docs/claude-code/terminal-config>

- Interactive mode

<https://docs.claude.com/en/docs/claude-code/interactive-mode>

- Visual Studio Code

<https://docs.claude.com/en/docs/claude-code/vs-code>
