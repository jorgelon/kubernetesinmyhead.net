# Context and memory

Giving a good context to claude code is one of the most important things to accomplish

We can give context to claude using different ways.

## Context via CLAUDE.md

When you run Claude in a directory Claude uses that directory as the current working context. It can access files within that directory (and subdirectories) and it looks for any CLAUDE.md files to gain additional context, but these are optional.

That files are pulled when starting a conversation and they can include any relevant information we can give to claude code:

- What is our project about, including environments, releases
- How we want organize the code, branches,...
- What utilities and commands we use
- What we want to test
- Code style guidelines
- Testing instructions
- and so on

### Locations

When we launch claude code in a directory, it search CLAUDE.md files in some locations:

- Project memory (./CLAUDE.md)

In the directory where claude was launched

- User memory (~/.claude/CLAUDE.md)

We can include here some personal preferences

- Parent (git)

If the directory is part of a git repository, in parent directories up to the root of the repo

- Subdirectories

If there are CLAUDE.md files in subdirectories, they are only included when Claude reads files in those subtrees, not at claude launch

> Using CLAUDE.local.md files is deprecated. Use imports instead

## Tips

The /init command reads the current and create a CLAUDE.md file
The /memory command permits to edit the user and current directory CLAUDE.md files

## Other ways to add context

- The # key adds context to memory and it will incorporated to the CLAUDE.md file

- The current selection/tab in the IDE is automatically shared with Claude Code context

- Diagnostic sharing

Diagnostic errors (lint, syntax, etc.) from the IDE are automatically shared with Claude as you work

## Links

- Manage Claude's memory

<https://docs.anthropic.com/en/docs/claude-code/memory>

- Outdated (warning)

<https://www.anthropic.com/engineering/claude-code-best-practices>
