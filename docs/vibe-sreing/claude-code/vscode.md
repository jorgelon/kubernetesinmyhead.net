
# Visual Studio Code

There is an official Claude Code VSCode extension available in the marketplace.

## Tips

### MCP settings file

- The VS Code Extension uses ~/.config/Code/User/mcp.json file to configure the mcp servers

- The Claude Code CLI users ~/.claude.json (the large history file)

- Enabling enableAllProjectMcpServers at claude code settings, automatically approves all MCP servers defined in project .mcp.json

### Auto installation

The /config command permits to enable|disable the autoinstallation of the claude code IDE extension, vscode in this case.
When you run claude under a vscode terminal, will will install the extension if it is enabled

## Check the integration with vscode

With the extension installed, this command manages the integration into vscode a show the status

```txt
/ide
```

### Open the extension

Executing claude under a vscode terminal does not opens the extension.
In order to open the extension you can:

- Click the Claude Code icon

- Use the Ctrl+Esc shortcut

There is a vscode setting that changes this behaviour and make this icon open the vscode terminal, not the extension tab

```txt
"claude-code.useTerminal": true
```

### Add multiline input

We can configure the vscode terminal to support multiline prompts, this is, when in the prompt, inserts a "\" and jumps to a new line.

This is done with the following builtin command:

```txt
/terminal-setup
```

### Add opened tab to context

We can add an opened tab (file) to a claude code prompt as context (using #), focusing the tab and pressing

```txt
ALT + CTRL + k
```

## Links

- Visual Studio Code

<https://docs.claude.com/en/docs/claude-code/vs-code>

- VS Code Extension (Beta)

<https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code>
