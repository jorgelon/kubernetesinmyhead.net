# Project

## What is a Claude Code Project?

A Claude Code project is simply any directory where you've launched the `claude` command or are interacting with Claude Code. There's no special "project file" or configuration required to designate a directory as a Claude Code project.

When you run Claude in a directory:

- Claude establishes that directory as the current working context
- It can access files within that directory and subdirectories
- It looks for CLAUDE.md files to gain additional context (optional)
- Claude becomes aware of your entire project structure

The project concept in Claude Code is more about providing a working context than a formal technical structure with required configuration files.

## Getting Started

To start using Claude Code in your project, simply navigate to your project directory and run the `claude` command. Claude Code will then be able to help you:

- Build features from descriptions
- Debug issues
- Navigate your codebase
- Automate various development tasks
- Find up-to-date information about your project

## Memory and Context Management

Claude Code manages memory and context through a hierarchical structure with three levels:

### Memory Types

1. **Enterprise Policy** (Organization-wide)
   - Stored in system-level CLAUDE.md files
   - Shared with all users in the organization
   - Highest precedence

2. **Project Memory** (Team-shared)
   - Stored in `./CLAUDE.md` or `./.claude/CLAUDE.md`
   - Contains project-specific instructions: architecture, coding standards, common workflows
   - Shared with team members via source control

3. **User Memory** (Personal)
   - Stored in `~/.claude/CLAUDE.md`
   - Contains personal preferences
   - Applies across all projects for an individual

### Memory Loading Behavior

- Memory files are automatically loaded when Claude Code launches
- Higher-level memories take precedence over lower-level ones
- The system recursively discovers memories from the current working directory upwards
- You can import additional memory files using `@path/to/import` syntax

## Project Configuration

### Project-Specific Settings

Projects can have their own Claude Code settings and configurations stored in `.claude/` directories:

- Project-specific subagents: `.claude/agents/`
- Project memory files: `.claude/CLAUDE.md`
- Custom slash commands
- Hooks and integrations

### Directory Structure Notes

- The folders under `~/.claude/projects/` can be safely deleted if you no longer need those projects
- This directory is a custom organization structure, not required by Claude Code
- You can organize your projects however works best for your workflow

## Team Collaboration

For Team and Enterprise plans, Claude Code projects can be shared among team members with premium seats, enabling:

- Collaborative development workflows
- Shared project memory and context
- Team-wide coding standards and practices
- Consistent development patterns across the team
