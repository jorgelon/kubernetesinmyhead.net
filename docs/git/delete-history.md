# Delete the git history

<https://stackoverflow.com/questions/13716658/how-to-delete-all-commit-history-in-github>
<https://stackoverflow.com/questions/76088396/gitlab-doesnt-allow-me-to-force-push-into-remote-repo-since-the-branch-is-prote>

Checkout/create orphan branch (this branch won't show in git branch command):

```shell
git checkout --orphan latest_branch
```

See what you need to include

```shell
git status
git add -A # if you want to add all
git commit -am "clean history"
```

Delete main branch

```shell
git branch -D main
```

Rename the current branch to main

```shell
git branch -m main
```

See the remotes and push changes
This ensures you don't overwrite other people's work

```shell
git remote  -v
git push --force-with-lease REMOTE main
```

## Gitlab: no allowed to force push

If your are pushing to gitlab and get this error "You are not allowed to force push code to a protected branch on this project"

Enable force push in the repository under Settings  > Repository > Protected branches

See the branch and enable "Allowed to force push" and repeat the push. After the push, disable it
