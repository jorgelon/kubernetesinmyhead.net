# Secure your git repositories

## Push control

These tools give you some control in your git clients before pushing to the repository

### Git secrets

<https://github.com/awslabs/git-secrets>

### Talisman

<https://github.com/thoughtworks/talisman>

### Pre-commit

<https://pre-commit.com/>

## Secret Scanners

These tools scan your git repositories searching exposed secrets and credentials

### TruffleHog

Documentation:  
<https://github.com/trufflesecurity/trufflehog>

### Gitleaks

<https://github.com/gitleaks/gitleaks>

### Git guardian

<https://www.gitguardian.com/>

### Detect-secrets

<https://github.com/Yelp/detect-secrets>

## Gitlab resources

### Static Application Security Testing (SAST)

This a gitlab tool to scan your code using Gitlab CI/CD. It supports things like:

- some programming languages
- kubernetes manifests
- helm-charts

Documentation:
<https://docs.gitlab.com/ee/user/application_security/sast/>

### Secret push protection

This feature available since Gitlab CE 17.3 can reject pushes when a secret in detected

<https://docs.gitlab.com/ee/user/application_security/secret_detection/secret_push_protection/index.html>

### Pipeline secret detection

This tools analyzes the code and git history searching for secrets

<https://docs.gitlab.com/ee/user/application_security/secret_detection/pipeline/>
