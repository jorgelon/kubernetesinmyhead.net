# Permission Modes

Claude Code has six permission modes that control how much Claude can do
without asking for approval.

## Modes at a Glance

| Mode                | Auto-approves                                 | Best for                                       |
|---------------------|-----------------------------------------------|------------------------------------------------|
| `default`           | Reads only                                    | Getting started, sensitive work                |
| `acceptEdits`       | Reads + file edits + safe filesystem commands | Iterating on code you'll review afterward      |
| `plan`              | Reads only (no execution)                     | Exploring changes before committing            |
| `auto`              | Everything with AI safety checks              | Long tasks; reduces approval fatigue           |
| `dontAsk`           | Only pre-approved tools                       | CI pipelines, headless/non-interactive scripts |
| `bypassPermissions` | Everything (except protected paths)           | Isolated containers/VMs only                   |

## Mode Details

### default

Prompts before each tool type is used for the first time. Read-only
operations (Read, Grep, Glob) run without asking. File edits, shell
commands, and network requests all require explicit approval.

### acceptEdits

Auto-approves file edits and common filesystem commands (`mkdir`, `touch`,
`rm`, `mv`, `cp`, `sed`). All other Bash commands and network requests
still require approval. Only applies within the working directory or
`additionalDirectories`.

### plan

Claude reads and explores, then proposes a plan — but does not execute any
edits. Use this to review what Claude intends to do before it acts. After
reviewing the plan, switch to `default` or `acceptEdits` to approve.

### auto

A background classifier model reviews each action before execution. It
blocks risky operations by default:

- `curl | bash` patterns (download and execute)
- Sending sensitive data to external endpoints
- Production deploys and migrations
- Mass deletion on cloud storage
- IAM/repo permission grants
- Force push or push to `main`
- Destructive operations on pre-existing files

Safe local operations, dependency installs, and read-only HTTP requests are allowed.

If the classifier blocks too many times in a row or in total, auto mode
pauses and falls back to normal prompting.

**Requirements**: Team/Enterprise/API plan (not Pro/Max), Sonnet 4.6 or
Opus 4.6 model, Anthropic API only (no Bedrock/Vertex/Foundry). Admin must
enable it in Claude Code admin settings.

### dontAsk

Auto-denies any tool not explicitly listed in `permissions.allow`. No
prompts are shown; tools not on the allow list are blocked outright.
Intended for fully non-interactive CI environments.

### bypassPermissions

Disables all permission prompts. Use **only in isolated containers or VMs
without internet access** — there are no safety guarantees and no
protection against prompt injection. Deny rules and hooks still apply.
Writes to protected paths still prompt.

## Protected Paths

These paths always prompt regardless of mode:

- `.git`, `.vscode`, `.idea`, `.husky`
- `.claude` (except `.claude/commands`, `.claude/agents`, `.claude/skills`)
- `.gitconfig`, `.gitmodules`, `.bashrc`, `.zshrc`, `.profile`, `.mcp.json`, `.claude.json`

## How to Set the Mode

**CLI flag at startup**:

```bash
claude --permission-mode acceptEdits
claude --enable-auto-mode        # also adds auto to Shift+Tab cycle
```

**Persistent default in `settings.json`**:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

**During a session** — press `Shift+Tab` to cycle through `default`,
`acceptEdits`, and `plan`. `auto` and `bypassPermissions` only appear in
the cycle if explicitly enabled:

```bash
# Enable auto in the cycle
claude --enable-auto-mode

# Enable bypassPermissions in the cycle
claude --permission-mode bypassPermissions
# or
claude --dangerously-skip-permissions
```

Or set `defaultMode` in `settings.json` to `auto` or `bypassPermissions`
to enable them persistently.

`dontAsk` never appears in the cycle; it must be set via flag or settings.

**VS Code**: click the mode indicator at the bottom of the prompt box.

## Security Notes

- Deny rules take precedence over allow rules in **all** modes, including `bypassPermissions`.
- `allowedTools` does **not** constrain `bypassPermissions` — all tools
  run.
- `bypassPermissions` is not a full bypass: protected paths, hooks, and
  deny rules still apply.
- Subagents inherit the parent session's tool allow/deny rules.

## Links

- [Permission modes](https://docs.anthropic.com/en/docs/claude-code/settings#permission-modes)
- [Configure permissions](https://docs.anthropic.com/en/docs/claude-code/settings#permissions)
