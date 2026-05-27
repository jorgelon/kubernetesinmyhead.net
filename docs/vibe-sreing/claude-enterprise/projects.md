# Claude Enterprise Projects

A Claude project is a workspace that groups related conversations with shared context: a knowledge base of files, custom instructions, and memory. Everything uploaded to a project is available across all chats within it.

Projects are distinct from git repositories or Claude Code projects — they live in the claude.ai web interface and have no effect on Claude Code sessions. Claude Code has its own persistence mechanisms (`CLAUDE.md`, `.mcp.json`, auto memory).

## Components

### Instructions

Custom instructions that tailor Claude's behavior for the project — tone, role, domain focus, output format. Applied to every chat in the project.

### Files (knowledge base)

Upload PDFs, documents, code snippets, or text files. Claude uses them as context across all chats in the project. On paid plans, when the knowledge base approaches the context window limit, Claude automatically enables RAG mode to expand capacity.

> Context is not shared across chats unless the information is in the project knowledge base.

### Memory

Claude maintains a separate memory summary per project, built from chat history. On Team and Enterprise plans this is available on web, desktop, and mobile. Memory is scoped to the project — non-project chats have their own separate summary.

## Visibility and sharing

Projects on Team and Enterprise plans can be shared with organization members.

| Visibility | Who can access               |
|------------|------------------------------|
| Private    | Only invited members         |
| Public     | Everyone in the organization |

| Permission | Capabilities                                                            |
|------------|-------------------------------------------------------------------------|
| Can view   | Read project contents, knowledge, instructions; chat within the project |
| Can edit   | Modify instructions and knowledge, manage members                       |

Chats within a project are always private to the author, even in a public project, unless manually shared. Shared projects appear in the **Shared with me** tab; members receive an email notification when a project is shared with them.

## Activity tab

The **Activity** tab shows actions taken within the project across members, useful for team visibility into how the project is being used.

## Claude Cowork projects

Cowork (desktop app) has its own project concept — local workspaces with their own files, context, instructions, and memory. Key differences from web projects:

- Stored locally on the desktop, no cloud sync
- Do not support project sharing on Team and Enterprise plans
