# Hooks

Hooks are automated scripts that intercept and modify various stages of Claude's interaction with tools and the development environment. They're configured in settings files like `~/.claude/settings.json`.

**Hook Events:**

- **PreToolUse**: Before a tool is used
- **PostToolUse**: After a tool completes
- **UserPromptSubmit**: When a user submits a prompt
- **SessionStart/End**: At session initialization or conclusion

**Capabilities:**

- Validate tool usage and control permissions
- Add context to interactions automatically
- Log operations for auditing
- Perform security checks

**Important Notes:**

- Hooks execute shell commands automatically (60-second default timeout)
- Users are solely responsible for configured commands
- Hooks run in parallel
- Environment variables like `CLAUDE_PROJECT_DIR` are available
