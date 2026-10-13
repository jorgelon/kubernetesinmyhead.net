# Platform differences

This document describes how to apply the [image build](image-build.md) patterns on each CI platform.
The patterns are the same on all platforms. Only the variable names, the triggers and the tools change.

## Tools

On GitHub, `docker/metadata-action` computes the tags from the git event, and `docker/build-push-action` builds and pushes the image.
With `docker/metadata-action`, `tags: type=sha` creates `sha-<7 characters>`. The `prefix` and `format=long` options change it.

On GitLab, the `Docker.gitlab-ci.yml` template tags only with the branch slug (`$CI_COMMIT_REF_SLUG`) and adds `latest` on the default branch.
The template does not run on tag pipelines. Auto DevOps tags with the full commit SHA.
The open source [to-be-continuous Docker template for GitLab](https://to-be-continuous.gitlab.io/doc/ref/docker/) adds snapshot images, semver tags and a promotion with `skopeo`.

None of these tools makes sure that a release is the highest version before it moves `latest`, `1` or `1.4`.
Use the [tags calculation script](tags.sh) for that.

## Input variables for the tag script

| Script input     | GitHub Actions                           | GitLab CI/CD                                     |
|------------------|------------------------------------------|--------------------------------------------------|
| `REF_TYPE`       | `GITHUB_REF_TYPE` (`branch` or `tag`)    | `tag` when `CI_COMMIT_TAG` exists, or `branch` |
| `REF_NAME`       | `GITHUB_REF_NAME`                        | `CI_COMMIT_REF_NAME`                             |
| `COMMIT_SHA`     | `GITHUB_SHA`                             | `CI_COMMIT_SHA`                                  |
| `DEFAULT_BRANCH` | `${{ github.event.repository.default_branch }}` | `CI_DEFAULT_BRANCH`                       |

## Short SHA

GitHub Actions gives only the full `GITHUB_SHA`. You can cut it with `echo "SHORT_SHA=${GITHUB_SHA::7}" >> "$GITHUB_ENV"` or use `git rev-parse --short HEAD`.
GitLab gives `CI_COMMIT_SHORT_SHA` with the first 8 characters of the commit SHA.

## Merge request commit

On a GitHub `pull_request` event, `GITHUB_SHA` is the temporary merge commit and not the head of the branch.
If you want the branch commit, use `github.event.pull_request.head.sha`.
With `docker/metadata-action`, set the environment variable `DOCKER_METADATA_PR_HEAD_SHA: true`.

On GitLab, a merge request pipeline uses the branch head in `CI_COMMIT_SHA`.
A merged results pipeline uses the temporary merge commit. The branch head is in `CI_MERGE_REQUEST_SOURCE_BRANCH_SHA`.

## Triggers

| Event                 | GitHub Actions                     | GitLab CI/CD                                         |
|-----------------------|------------------------------------|------------------------------------------------------|
| Push to a branch      | `on: push: branches`               | `if: $CI_COMMIT_BRANCH`                              |
| Push to main          | `on: push: branches: [main]`       | `if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH`        |
| Merge request         | `on: pull_request`                 | `if: $CI_PIPELINE_SOURCE == "merge_request_event"`   |
| Tag push              | `on: push: tags: ['v*.*.*']`       | `if: $CI_COMMIT_TAG =~ /^v?\d+\.\d+\.\d+/`           |
| Files that start a build | `paths` filter                  | `rules: changes`                                     |

The file filters do not work on tag pushes. GitHub ignores `paths` for tags, and GitLab `rules: changes` is always true for tags.
If the branch also has an open merge request, GitLab can start a branch pipeline and a merge request pipeline for the same commit.
Use `workflow: rules` to keep only one of them.

## Full clone

The tag script needs all git tags.

- GitHub: `actions/checkout` fetches one commit by default. Set `fetch-depth: 0`.
- GitLab: the default clone depth is 20 for new projects. Set the variable `GIT_DEPTH: 0`.

## Registry credentials

| Registry           | GitHub Actions                                          | GitLab CI/CD                                       |
|--------------------|---------------------------------------------------------|----------------------------------------------------|
| Built-in registry  | `ghcr.io` with `GITHUB_TOKEN` and `permissions: packages: write` | `$CI_REGISTRY` with `$CI_REGISTRY_USER` and `$CI_REGISTRY_PASSWORD` |
| Other registries   | `docker/login-action` with secrets or OIDC              | CI/CD variables or ID tokens (OIDC)                |

For crane on GitLab, log in with `crane auth login "$CI_REGISTRY" -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD"`.

## Merge requests from forks

On GitHub, a `pull_request` from a fork gets no secrets, and `GITHUB_TOKEN` is read-only. The pipeline can only build.
On GitLab, a merge request from a fork runs the pipeline in the fork project, with the CI/CD variables of the fork.
A maintainer of the parent project can run the pipeline in the parent project.

## Ephemeral environments

The Argo CD [SCM Provider Generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-SCM-Provider/) and [Pull Request Generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Pull-Request/) support GitHub and GitLab.
Each generator has a `github` and a `gitlab` block with its own token configuration.

## Links

- [GitHub Actions variables](https://docs.github.com/en/actions/reference/workflows-and-actions/variables)
- [GitLab predefined CI/CD variables](https://docs.gitlab.com/ci/variables/predefined_variables/)
- [Docker metadata action](https://github.com/docker/metadata-action)
- [Docker build push action](https://github.com/docker/build-push-action)
- [To be continuous for GitLab](https://to-be-continuous.gitlab.io/doc/ref/docker/)
