# Claude code project

A Claude Code project is simply any directory where you've launched the Claude command or are interacting with Claude Code.

There's no special "project file" or configuration needed to designate a directory as a Claude Code project. When you run Claude in a directory:

- Claude uses that directory as the current working context
- It can access files within that directory (and subdirectories)
- It looks for any CLAUDE.md files to gain additional context, but these are optional

The project concept in Claude Code is more about providing a working context than a formal technical structure with required configuration files.

The folders under ~/.claude/projects/ can be safely deleted if you no longer need those projects. This directory appears to be a custom organization structure rather than something specifically required by Claude Code.

The Claude Code tool itself doesn't depend on this specific directory structure, so you can organize your projects however works best for your workflow.
