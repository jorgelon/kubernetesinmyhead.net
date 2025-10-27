# MCP servers

Model Context Protocol (MCP) is a standardized protocol that allows Claude Code to connect with external tools, services, and data sources.

**Purpose:**

- Connect Claude to hundreds of tools and data sources
- Enable complex interactions across different platforms
- Extend Claude Code's capabilities beyond built-in tools

**Server Types:**

1. Remote HTTP servers
2. Remote SSE servers
3. Local stdio servers

**Installation Scopes:**

- **Local**: Project-specific, private configuration
- **Project**: Shared team configuration
- **User**: Available across multiple projects

**Key Features:**

- OAuth 2.0 authentication support
- Environment variable expansion
- Resource referencing via @ mentions
- Slash commands for quick actions

**Example Use Cases:**

- Fetch Sentry error logs
- Review GitHub pull requests
- Query PostgreSQL databases
- Create Jira tickets
- Integrate with monitoring tools
