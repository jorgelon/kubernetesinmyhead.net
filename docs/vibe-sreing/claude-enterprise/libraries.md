# Claude Enterprise Libraries: Plugins, Skills & Connectors

Claude Enterprise provides three types of extensibility mechanisms that allow organizations to expand Claude's capabilities and integrate it with external services.

## Plugins

Plugins are managed marketplaces that organization members can browse, install, and customize. Admins control which plugins are available to users.

### Plugin management

- Plugins are added by organization admins via **Settings > Plugins > Add plugins**
- Official plugins are curated **By Anthropic & Partners** and tagged as `Official` or `GitHub`
- Each plugin shows its name, last updated date, and user access level
- User access can be set to **Available to install** or restricted

### Official plugins

Curated by Anthropic & Partners, tagged as `Official` or `GitHub`. The catalog includes 46+ plugins covering categories like security, automation, finance, design, and productivity.

### Custom plugins

Organizations can add custom plugins beyond the official catalog using the **+ Add plugins** button.

### Plugin structure

A plugin is a reusable capability package that bundles together MCP connectors, skills, slash commands, and sub-agents into a single shareable unit.

```text
my-plugin/
├── .claude-plugin/
│   └── plugin.json        # mandatory — name, description, version
├── version.json           # triggers re-sync when changed
├── .mcp.json              # MCP connector config
├── agents/
│   └── my-agent.md        # sub-agent definitions
├── commands/
│   └── my-command.md      # slash command definitions
└── skills/
    └── my-skill/
        └── SKILL.md       # skill definition
```

The `.claude-plugin/plugin.json` file is mandatory — directories without it are ignored. Changes to `version.json` trigger a re-sync on next launch.

Each component is optional except `plugin.json`:

| Component   | Purpose                                                          |
|-------------|------------------------------------------------------------------|
| `.mcp.json` | MCP connector configuration for external services                |
| `agents/`   | Sub-agent definitions (markdown files)                           |
| `commands/` | Custom slash commands (markdown files)                           |
| `skills/`   | Reusable behaviors with optional scripts, references, and assets |

---

## Connectors

Connectors are MCP servers that allow Claude to access and interact with external services and data sources. They are managed under **Settings > Connectors**.

### Connector types

| Type               | Description                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------|
| Built-in           | Anthropic-managed remote MCP servers (Asana, Figma, GitHub, etc.)                                    |
| Custom             | Your own remote MCP server, reachable over the public internet (Anthropic connects from their cloud) |
| Desktop extensions | Local MCP servers for on-premises resources behind a firewall — no VPN or firewall rules needed      |

### Security

Connectors use per-user OAuth. Claude inherits the individual user's permissions in the connected tool — there are no shared service accounts with elevated access. On Team and Enterprise plans, an Owner must enable a connector before members can use it, and each user authenticates individually.

### Adding connectors

Use **+ Add** in the Connectors settings page. You can filter by **Type** and **Categories** to find the right connector.

---

## Skills

Skills extend Claude's behavior with reusable capabilities. They can contain executable code and are managed under **Settings > Skills**.

### Skill settings

| Setting                          | Description                                                                                                                                                        |
|----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Code execution and file creation | Allows Claude to execute code and create/edit docs, spreadsheets, presentations, PDFs, and data reports. Available on web and desktop. Applies to all org members. |
| Skills                           | Master toggle for all skills org-wide, including admin-managed organization skills. Requires *Code execution and file creation* to be enabled.                     |
| User-created skills              | Allows team members to upload or create their own skills. Disable to lock the org to approved skills only.                                                         |
| Skill sharing                    | Allows team members to share skills with each other.                                                                                                               |
| Share with organization          | Allows team members to share skills with the entire organization.                                                                                                  |

> **Security note:** Skills might contain executable code. Team members should be careful when using skills from unknown sources.

### Organization skills

Admins can manage skills that are available to everyone in the organization via **Settings > Skills > Organization skills > + Add**. These are centrally controlled and visible to all org members.

### Skill hierarchy

```text
Organization skills (admin-managed)
└── Shared skills (team member shared, if enabled)
    └── User-created skills (individual, if enabled)
```
