# Remote branches tips

## Get remote branches

To get the remote branches we must using git fetch

```shell
git fetch
```

This gets the remote branches from the default remote of the current branch. If the current branch tracks origin/main, it fetches updates from origin. If there's no tracking branch configured, it defaults to the remote named origin if it exists.

To see what remote your current branch tracks:

```shell
git branch -vv
```

We can also specify the remote

```shell
git fetch origin
```

Get the from all remotes

```shell
git fetch --all
```

### About git fetch and git pull

Git fetch only downloads commits, files, and refs from remote but doesn't modify the working directory

- Updates remote-tracking branches (e.g., origin/main)
- Safe operation - won't affect your current work
- Lets you review changes before integrating

```shell
git fetch origin
git log origin/main  # Review what's new
git merge origin/main  # Merge when ready
```

> Use fetch when you want to see what changed before integrating.

Git pull does git fetch + git merge (or rebase)

- Downloads remote changes AND merges them into your current branch
- Modifies your working directory immediately
- Can cause merge conflicts if you have local changes

```shell
  git fetch
  git diff main origin/main # See what's different before pulling
  git pull  # Now merge. git pull --all from all remotes
```

> Use pull when you're ready to update immediately.

## Local References

To see local references to remote branches we can use

```shell
git branch --remotes # -r
```

If we want to remove local references to remote branches that they do not exists, we can use the --prune parameter

```shell
git fetch --all --prune
```
