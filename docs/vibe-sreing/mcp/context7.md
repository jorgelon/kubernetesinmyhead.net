# Context7

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
