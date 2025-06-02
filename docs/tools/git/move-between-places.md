# Move between places

## Working directory

The working directory or working tree is the directory that containes the files we are working with.

Inside the working directory we can find tracked an untracked files.

### Tracked files

Tracked files are files that git knows about, they were in the last snapshot. They can be:

- unmodified

No changed made from the last snapshot

- modified

With pending changes from the last snapshot

- staged

Added to the staging area

> the git status command show the different status of a file.

### Untracked files

Untracked files are files in the working directory not included in the last snapshot and they are not in the staging area.

## Staging area or index

## HEAD

## Movements

We can move files from one state to another

| From                       | to                         | Command                                |
|----------------------------|----------------------------|----------------------------------------|
| untracked or modified file | staging area               | git add                                |
| staging area               | next snapshot              | git commit                             |
| modified file              | unmodified file            | git restore (--worktree)               |
| staging area               | untracked or modified file | git restore --staged or git reset HEAD |

checkout

## Links

- Recording Changes to the Repository

<https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository>

- Undoing Things

<https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things>

- Reset Demystified
<https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified>

<https://git-scm.com/docs/git-add>
<https://git-scm.com/docs/git-reset>
<https://git-scm.com/docs/git-checkout>
<https://git-scm.com/docs/git-restore>
