# Context

We can give context to cloude code

## Choosing the directory

When you run Claude in a directory Claude uses that directory as the current working context. It can access files within that directory (and subdirectories) and it looks for any CLAUDE.md files to gain additional context, but these are optional

## Context via CLAUDE.md

It is recommended to give a good context to claude code via CLAUDE.md files. That files are pulled when starting a conversation and they can include any relevant information we can give to claude code:

- What is our project about, including environments, releases
- How we want organize the code, branches,...
- What utilities and commands we use
- What we want to test
- Code style guidelines
- Testing instructions
- and so on

### Locations

We can put CLAUDE.md in some locations

| Location              | Description and notes                                                                                        |
|-----------------------|--------------------------------------------------------------------------------------------------------------|
| repo/CLAUDE.md        | Root of the git repo where you run claude command. It will be shared with the team                           |
| repo/CLAUDE.local.md  | Root of the git repo (not shared) where you run claude command. Add it to .gitignore file to make it private |
| repo/subdir/CLAUDE.md | Add specific context from that directory                                                                     |
| ~/.claude/CLAUDE.md   | Applies to all claude sessions created by the current user                                                   |

The /init command reads the folder and create a CLAUDE.md file

## Add to memory

The # key adds context to memory and it will incorporated to the CLAUDE.md file
