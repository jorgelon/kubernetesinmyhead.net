# Detached head

A detached HEAD is a Git state where HEAD points directly to a specific commit instead of pointing to a branch reference.

- Normal state

```shell
git checkout branch
```

```txt
HEAD -> main -> commit abc123
HEAD points to main, which points to a commit.
```

- Detached HEAD:

```shell
git checkout commitid
```

```txt
HEAD -> commit abc123
HEAD points directly to a commit, not through a branch.
```

## Notes

- CI/CD pipelines often checkout specific commits (like GitLab does with git checkout 35ff590b)

- If you want to push the branch, you can get this error

```txt
error: src refspec MYBRANCH does not match any
error: failed to push some refs to 'MYREPO'
```

This is because git looks for a local branch named MYBRANCH to push. In detached HEAD state, there's no local main branch reference, so it fails.

Solution: Using git push origin HEAD:MYBRANCH pushes whatever HEAD points to (the commit) directly to the remote main branch
