# Git refs

A git ref (reference) is a human-readable name that points to a commit ID. With refs, you do not need to remember long SHA-1 hashes.

## Where git stores refs

Git stores most refs as small files under `.git/refs/`. Each file holds the hash of one commit.

| Ref type               | Location        | Example                    |
|------------------------|-----------------|----------------------------|
| Branch                 | `refs/heads/`   | `refs/heads/main`          |
| Tag                    | `refs/tags/`    | `refs/tags/v1.0.0`         |
| Remote-tracking branch | `refs/remotes/` | `refs/remotes/origin/main` |

A remote-tracking branch is a local copy of the state of a branch on a remote.

```shell
cat .git/refs/heads/main
```

Git can also pack many refs into one file, `.git/packed-refs`. If you do not find a ref under `.git/refs/`, look in that file.

## HEAD and symbolic refs

`HEAD` is a special ref. It usually points to another ref (the current branch), not to a commit.

A symbolic ref is a ref that points to another ref. `HEAD` is the most common example.

```shell
cat .git/HEAD
# ref: refs/heads/main

git symbolic-ref HEAD
# refs/heads/main
```

If `HEAD` points directly to a commit, you are in a detached HEAD state. See [Detached HEAD](detached-head.md).

## Useful commands

List all refs:

```shell
git show-ref
```

Show the commit that a ref points to:

```shell
git rev-parse main
git rev-parse origin/main
```

List refs with a custom format:

```shell
git for-each-ref --format='%(refname) %(objectname:short)' refs/heads/
```

## Refs in GitOps

The `targetRevision` field in an Argo CD Application accepts a ref, such as a branch or a tag. It also accepts a commit SHA.

```yaml
spec:
  source:
    repoURL: https://provider.com/organization/repository.git
    targetRevision: v1.0.0
    path: manifests
```
