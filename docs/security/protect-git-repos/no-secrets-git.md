# Protect your git repos from including secrets

## Client-side pre-commit hook

The pre-commit hook is the first client-side git hook to run when a commit is executed and the best option to check if contains any secret. Every non-zero exit aborts the commit and it can be bypassed using

```shell
git commit --no-verify
```

### Gitlab implementation (pre-commit hook)

- Client-side secret detection

<https://docs.gitlab.com/ee/user/application_security/secret_detection/client/index.html>

### Related tools

- Pre-commit

<https://pre-commit.com/>

## Server-Side and the pre-receive hook

The pre-receive hook is the first server-side git hook to run when a push is executed and the best option to check if contains any secret.
Every non-zero exit rejects the push.

### Gitlab implementations (pre-receive hook)

- Gitlab customized pre-receive hook

In Gitlab you can create your own pre-receive hook

<https://docs.gitlab.com/ee/administration/server_hooks.html>

- Gitlab Secret push protection

Also in Gitlab, you can use the Secret Push Protection feature, available since 17.2 release.

<https://docs.gitlab.com/ee/user/application_security/secret_detection/secret_push_protection/index.html>

## After the push

### Gitlab CI/CD implementation

You can use the detection of secrets inside a pipeline and protect branches. For example, you can:

- Protect a branch

Located in Settings - Repository - Protected branches, prevent direct pushes to important branches and require changes to go through merge requests.

- Enable "Pipelines must succeed"

Located in Settings - Merge requests - Merge checks and enabling the "Pipelines must succeed" option, this ensures that the pipeline must pass before a merge request can be merged.

- Scan the code

Use a tool in the pipeline to scan the code and ensure it fails if a secret is detected.

Another gitlab related options are:

- Pipeline secret detection

<https://docs.gitlab.com/ee/user/application_security/secret_detection/pipeline/index.html>

- Gitlab Static Application Security Testing (SAST)

This a gitlab tool to scan your code using Gitlab CI/CD. It supports some programming languages, kubernetes manifests and helm-charts

<https://docs.gitlab.com/ee/user/application_security/sast/>

## Tools

These tools are related with implementing scans in pre-commit hooks, pre-receive hooks and pipelines.

- Gitleaks

<https://github.com/gitleaks/gitleaks>

- Trufflehog

<https://github.com/trufflesecurity/trufflehog>

- Git guardian

<https://www.gitguardian.com/>

- Detect secrets

<https://github.com/Yelp/detect-secrets>

- Git-secrets

<https://github.com/awslabs/git-secrets>

- Talisman

<https://github.com/thoughtworks/talisman>

## Links

- Customizing Git - Git Hooks  
<https://git-scm.com/book/ms/v2/Customizing-Git-Git-Hooks>

- Gitlab Secret detection  
<https://docs.gitlab.com/ee/user/application_security/secret_detection/>
