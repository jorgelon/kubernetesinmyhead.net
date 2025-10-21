# Context7

## Overview

Context7 is an MCP (Model Context Protocol) server developed by Upstash that provides up-to-date, version-specific code documentation directly into AI coding assistants' context. It solves the common problem of AI models using outdated or generic library information by fetching real-time, accurate code examples and documentation.

## Key Features

- **Version-Specific Documentation**: Provides current documentation for specific library versions
- **Real-Time Context**: Fetches up-to-date code examples and API references
- **Eliminates Hallucinations**: Prevents AI-generated outdated or incorrect APIs
- **Multi-Platform Support**: Works with Cursor, VS Code, Claude Code, and other AI coding platforms
- **Flexible Deployment**: Supports both remote and local server connections
- **Rate Limiting**: Optional API key for higher rate limits and private repository access

## How It Works

1. User adds "use context7" to their prompt in supported AI coding platforms
2. The system fetches current, version-specific documentation for the requested library or framework
3. AI assistant receives accurate, up-to-date information for code generation

## Benefits

- More accurate AI-assisted coding with current documentation
- Reduces debugging time from outdated API usage
- Access to latest library features and best practices
- Eliminates need to manually search for documentation

## Requirements

- Node.js v18.0.0 or higher

## Claude code

Claude Code Remote Server Connection

```shell
claude mcp add --transport http context7 <https://mcp.context7.com/mcp> --header "CONTEXT7_API_KEY: YOUR_API_KEY"
```

Claude Code Local Server Connection

```shell
claude mcp add context7 -- npx -y @upstash/context7-mcp --api-key YOUR_API_KEY
```

## VSCODE

VS Code Remote Server Connection

```json
"mcp": {
  "servers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "YOUR_API_KEY"
      }
    }
  }
}
```

VS Code Local Server Connection

```json
"mcp": {
  "servers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_API_KEY"]
    }
  }
}
```

## Links

- Context7 website

<https://context7.com/>

- Context7 github

<https://github.com/upstash/context7>
