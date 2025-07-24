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

## Pre-commit

<https://pre-commit.com/>

## Husky

<https://typicode.github.io/husky/>

## Links

<https://docs.trufflesecurity.com/pre-commit-hooks>
