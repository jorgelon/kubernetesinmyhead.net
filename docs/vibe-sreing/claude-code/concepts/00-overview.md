# Concepts Overview

Core building blocks that explain how Claude Code works and how to configure it.

## Documents

| Document                         | Summary                                                                      |
|----------------------------------|------------------------------------------------------------------------------|
| [Context window](01-context.md)  | How Claude manages active information, compaction, and context size by model |
| [Project](02-project.md)         | What a Claude Code project is, memory hierarchy, team collaboration          |
| [MCP servers](03-mcp-servers.md) | Connecting external tools and data sources via the Model Context Protocol    |
| [Tools](04-tools.md)             | Built-in tools, the agentic loop, permissions, and settings.json reference   |
| [Models](05-models.md)           | Model aliases, switching, effort levels, extended context, prompt caching    |

## How they relate

```text
Model ──────────────────► sets reasoning depth + context window size
        │
        ▼
Context window ◄──────── Tools feed results back into it each step
        │
        ▼
Project (working dir) ◄── MCP servers extend what tools can reach
```

- **Model** determines what Claude can reason about and how far back it can see.
- **Context window** is the live workspace — tools write results into it, compaction trims it.
- **Project** defines the directory scope and loads the memory layer on top.
- **MCP servers** expand the tool surface beyond built-ins.
- **Tools** are the actions Claude takes inside the agentic loop.

For persistent behavior configuration (memory, hooks, agents, skills) see [Persistence](../persistence/00-overview.md).
