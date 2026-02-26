# Tips

## Use claude code to setup claude code

You can use claude code itself to manage thinks like:

- settings.json
- agents
- custom slash commands
- agent skills

## Clear context

Use the /clear command frequently between tasks and conversations to reset the context window.

## Share context

Share CLAUDE.md context pushing them to the git repository

## VS code problems

Use mcp__ide__getDiagnostics to fix problems detected in VScode problems tab

## Use commands

Use commands for common tasks

## Working with conversations

Continue the last conversation

```shell
claude -c
claude --continue
```

Open an interactive menu to choose from last conversations

```shell
claude -r
claude --resume
```

From claude prompt, this makes the same

```shell
/resume
```

Choose a conversation to resume

```shell
claude -r conversationid
claude --resume  conversationid
```
