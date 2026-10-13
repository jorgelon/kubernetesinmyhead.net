# Image build

This document includes some patterns in order to decide when and how to generate container images when a developer works

## Local test

In this case the developer is doing some changes in the code but no commit/pushes are done to the git repository. The developer wants to try that changes locally

Here the developer builds the image manually and starts the container image locally. It can be necessary to have connectivity with some non-local services in non production environments. No push to container registry is done. Nothing enters the git repository.

To run the image in a local cluster (kind, minikube or k3d), the developer loads the image into the cluster, for example with `kind load docker-image`. No registry and no pipeline take part.

What the pipeline does:

- No pipelines are triggered

## Push to non main branches or merge requests to main

This is when the developer commit and pushes changes to git in non main branches or makes a merge request to main.
In this case a pipeline always build the image with the following tag: `<branch>-<short>` but we have some options about pushing the image and deploy it:

### No deployment is needed

The simplest solution to only build the image as a proof. No push/deploy is done in the pipeline

### A deployment is needed

These images must be considered short-lived so it is recommended to push them to a non production registry with a cleanup policy for `<branch>-<short>` images.

The deployment can done in two environment tyes

#### A long living environment (shared dev)

If using gitops, in this case the new image must configured in the manifests to be deployed.

#### An ephemeral preview environment

We can achieve this with an argocd applicationset

- For non main pushes Argocd has the [SCM Provider Generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-SCM-Provider/) that can be used for that purpose. Set `allBranches: true` to get one environment per branch. The ephemeral environment is deleted when someone deletes the branch
- For merge requests Argocd provides the [Pull Request Generator](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Generators-Pull-Request/). In this case the ephemeral environment is gone when the merge request closes or merges.

### How the developer can trigger the build and deploy

The developer can trigger the deploy in these ways:

1. A manual job. The DevOps engineer adds the deploy job, and the developer starts it by hand.
    - GitLab: the job has `when: manual` and `allow_failure: true`. In the pipeline view, the developer clicks the play button of the job.
    - GitHub: the job uses an environment with required reviewers. The developer clicks "Review deployments" in the run. Private repositories need GitHub Enterprise.
    - GitHub: a `workflow_dispatch` workflow gives a "Run workflow" button. It starts a new full run for the branch that the developer selects.
2. A `preview` label. The developer adds the label to an open merge request in the "Labels" field of the sidebar.
    - CI builds and pushes the image with the SHA of the merge request. The ArgoCD Pull Request Generator with `labels: [preview]` creates the environment.
    - If the developer removes the label or the merge request closes or merges, ArgoCD deletes the environment. For GitLab, set `pullRequestState: opened`, because the default is all states.
    - GitLab: a label change does not start a pipeline. The developer pushes a commit or clicks "Run pipeline" in the merge request.
    - GitHub: a label change starts the workflow with `pull_request` `types: [labeled, synchronize]`. The job checks the label with `contains(github.event.pull_request.labels.*.name, 'preview')`.
    - GitHub: tag the image with `github.event.pull_request.head.sha`, not `github.sha`. The `github.sha` value is the temporary merge commit.
3. A `preview/` prefix. The developer names the branch, for example `preview/login-fix`. No merge request or label is necessary.
    - CI builds and pushes the image at every push to the branch, with the SHA of the commit.
    - The ArgoCD SCM Provider Generator with `allBranches: true` and `branchMatch: '^preview/.*'` creates the environment. Use `branchNormalized` in names, because `/` is not valid in Kubernetes names.
    - If someone deletes the branch, the generator stops listing it and ArgoCD deletes the environment. Add a cleanup rule for old branches.
    - GitLab: the job has the rule `if: $CI_COMMIT_BRANCH =~ /^preview\//`.
    - GitHub: the workflow has `on: push: branches: ['preview/**']`.

### Devops engineer

| Value               | Value for this case                                                     |
|---------------------|-------------------------------------------------------------------------|
| Event type          | A push, a merge request event, or a "Run pipeline" click (`web`). Not a tag or a schedule. |
| Ref type            | A branch.                                                               |
| Ref name            | Not the default branch (`main`) and not a `release/*` branch.           |
| Trigger             | The manual job, the `preview` label, or the `preview/` prefix.          |
| Changed files       | The files between the previous commit and the new commit.               |
| Project of the push | The project itself. A fork never pushes.                                |

For a preview environment, also track the merge request number and its state (open or closed).

> Some platforms build a temporary merge commit (the branch merged into main) and not the branch head, so that commit has a different SHA, and the image tag must say which SHA it uses

What the pipeline does:

- Compare the changed files with the [files that start a build](98-tips.md#files-that-start-a-build). If no file changed, skip the build. If the developer clicks "Run pipeline", there is no previous commit, so the pipeline builds too.
- Build the container image with `<branch>-<short>`
- Optionally push the image to a dev registry and, if included in the pipeline, deploy to a dev environment
- If the image is pushed, print the image digest in the pipeline log
- Do not push moving tags such as `<branch>` or `latest`

## Commit to main or merge request completed

When a push to main is detected or a pull/merge request is completed a typical pattern is to generate images with `sha-<short>` and optionally `main` tag.
This gives an image for each merged commit before a release exists.

What the pipeline does:

- Build the container image and push it with `sha-<short>` and optionally `main`
- Optionally deploy it to a dev or staging environment

## Promotion: A tag is pushed

When a tag is pushed it is not necessary to build and push the image again because it should exist with `sha-<short>` in the registry. If a path filter skipped the build on main, the `sha-<short>` image does not exist. The promotion consists in tagging the `sha-<short>` image in the registry

But we can add additional controls here.

- We can filter the tags that generates images based on semver. For example, only 0.3.4 or v0.3.4 (less strict) tags generate images
- We can remove the `v` prefix from the git tag: `v1.4.2` becomes `1.4.2`.
- We can verify the tagged commit belongs only to a main or release/XXX branch

Also deploy it in the desired environment.

The devops engineer must track tag events

What the pipeline does (if using crane/krane/Gcrane):

- Make sure that the image exists (crane digest)
- If it does not exist it is possible to build it and push to the registry but a second build gives a different digest, so the released image is not the image that you tested.
- Adds a new tag to the `sha-<short>` image (crane tag) with the semver (ex: 1.4.2)
- If desired repeat the same for other moving tags (ex: 1.4, 1, latest)

> See the [tags calculation script](tags.sh). It prints the image tags for one git event. Map the input variables from your CI platform.
