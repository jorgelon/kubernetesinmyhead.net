# Pre commit hooks

## Git hooks

Create the .git/hooks/pre-commit file in your local repo and make it executable

```bash
cat << EOF > .git/hooks/pre-commit
#!/bin/bash
echo "Scanning commit with trufflehog"
trufflehog git file://. --since-commit HEAD --results=verified,unknown --fail
echo "Scanning commit with gitleaks"
gitleaks git --redact --staged --verbose
EOF
chmod u+x .git/hooks/pre-commit
```

### Sharing the git hooks with hooksPath

The git hooks stores in the hooks directory are not pushed to the remote repository. Each developer's hooks remain on their local machine only.
This must be executed by all users in the root of all local repositories.

An alternative approach is to store the hooks for example in another folder and push it to the repository

This changes the path where the hooks are located

```shell
git config core.hooksPath .githooks # the default value is .git/hooks
```

## Pre-commit framework

Another way to share the pre commit hooks is using the pre-commit framework.

For this you must :

- install this framework
- configure .pre-commit-config.yaml in the root of your git repo with your pre-commit hooks
- install the pre-commit scripts in your git repo

### Links and integrations

Pre-commit framework

<https://pre-commit.com/>

- Trufflehog

<https://docs.trufflesecurity.com/pre-commit-hooks>

- Gitleaks

<https://github.com/gitleaks/gitleaks>

- Talisman

<https://github.com/thoughtworks/talisman>

- Trivy

<https://github.com/mxab/pre-commit-trivy>

## Husky

pending

<https://typicode.github.io/husky/>
