# MCP Servers and Connectors in Claude

MCP (Model Context Protocol) servers are the underlying mechanism behind Claude connectors. They allow Claude to access external tools, data sources, APIs, and internal systems.

## Configuration scopes

MCP servers can be configured at four scopes. The scope controls which projects load the server and whether the configuration is shared.

| Scope        | Storage                             | Applies to                      |
|--------------|-------------------------------------|---------------------------------|
| Local        | `~/.claude.json` (per project path) | Only you, only that project     |
| Project      | `.mcp.json` in the repository       | Everyone who opens that project |
| User         | User settings                       | You, across all projects        |
| Organization | Admin console                       | All users in the organization   |

Per-group or per-team scoping is not currently supported. The closest approximation is the **project scope** via `.mcp.json`.

### Project scope — `.mcp.json`

Committing a `.mcp.json` file to a repository makes those MCP servers available to everyone working in that project. This is the recommended approach for team-level sharing without requiring org-wide rollout.

### Organization scope — admin console

Owners configure org-wide MCP servers from **Settings > Connectors**. Each user still authenticates individually — Claude inherits the user's own permissions in the connected tool, not a shared service account.

Server-managed settings (Claude Code v2.1.30+) allow central configuration of tool permissions, file access restrictions, and MCP server settings from the admin console with no MDM required. These settings occupy the highest tier in the settings hierarchy and cannot be overridden by users.

## Connector types

### Built-in connectors

Anthropic-managed remote MCP servers available out of the box. Enabled by an Owner in **Settings > Connectors**, then individually authenticated by each user.

### Custom connectors (remote MCP)

Connect Claude to your own remote MCP server. Requirements:

- Server must be reachable over the public internet (Anthropic connects from their cloud)
- Configured via **Settings > Connectors > + Add**
- Only Owners can add connectors on Team and Enterprise plans

### Desktop extensions (local MCP)

Installable packages that run an MCP server locally on the user's machine. Designed for on-premises or behind-firewall resources:

- Operates within the corporate network boundary
- Uses the user's existing SSO and browser sessions — no token management needed
- No inbound firewall rules or VPN configuration required
- Owners can upload custom extensions for one-click team install
- Owners can enable or disable public extensions org-wide

### MCP tunnels (private network)

For Claude Managed Agents accessing private infrastructure without exposing it to the public internet:

- A lightweight gateway makes a single **outbound** connection — no inbound firewall rules
- End-to-end encrypted
- Gives agents access to internal databases, private APIs, knowledge bases, and ticketing systems
- An agent can declare up to **20 MCP servers**

## Plugin integration

Plugins can bundle their own MCP connector configuration via a `.mcp.json` file in the plugin directory. See [libraries](libraries.md) for the full plugin structure.

## Timeouts

| Setting                           | Method                                                 |
|-----------------------------------|--------------------------------------------------------|
| Server startup timeout            | `MCP_TIMEOUT` environment variable                     |
| Per-server tool execution timeout | `timeout` field (ms) in the server's `.mcp.json` entry |
| Global tool execution timeout     | `MCP_TOOL_TIMEOUT` environment variable                |

Claude Code shows a warning when MCP tool output exceeds 10,000 tokens. Increase the limit with `MAX_MCP_OUTPUT_TOKENS`.
