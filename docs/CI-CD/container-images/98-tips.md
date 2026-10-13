# Best practices

This document includes best practices for the [image build](image-build.md) patterns.

## Files that start a build

If a commit changes a file that goes into the image, a build starts. A change to the Dockerfile or to the code is enough.

- The Dockerfile and `.dockerignore`.
- The source code.
- The dependency files, for example `package-lock.json` or `go.sum`.
- Any other file that the Dockerfile copies with `COPY` or `ADD`.
- The pipeline definition and the tag script, so that you can see that the pipeline still works.

A change to only `README.md` or `docs/` skips the build.

If the push is the first push of a new branch, no previous commit exists for the branch.
In this case, compare the new commit with the merge base on `main` (`git merge-base origin/main HEAD`).

If the branch also has an open merge request, the CI platform can start two pipelines for the same commit.
Make sure that only one of them builds the image.

## Branch images

- Do not push images from a laptop to the shared registry, because nobody can trace them to a commit.
- Do not use markers in commit messages to start a push, because they stay in the history.
- Do not push branch images from a merge request that comes from a fork.
- The dev repository deletes old images with a cleanup policy.
- Use `<branch>-<short>` or its digest in test clusters. Staging and production never use branch images.

## Image labels

Add the OCI annotations to each image, so that you can find the source of a running image.

| Label                               | Value                    |
|-------------------------------------|--------------------------|
| `org.opencontainers.image.source`   | Repository URL           |
| `org.opencontainers.image.revision` | Full commit SHA          |
| `org.opencontainers.image.version`  | `1.4.2` or `sha-<short>` |
| `org.opencontainers.image.created`  | Build time in RFC 3339   |

## Preview environments

These tips apply to the `preview` label and the `preview/` prefix patterns.

### Trigger and image

- Tag the image with the same SHA that the generator gives: `head_sha` for merge requests, `sha` for branches.
- Set `targetRevision` to the same SHA, so that the manifests and the image come from one commit.
- For GitLab merge requests, set `pullRequestState: opened`. The default value reads all states.
- The default `requeueAfterSeconds` is 30 minutes. Set a shorter value, or send a webhook to the ApplicationSet controller.
- The ApplicationSet webhook uses port 7000 of the ApplicationSet controller, not `argocd-server`.
- Some label events fail on the webhook. Keep a polling interval as a fallback.
- Use a read-only token in `tokenRef`. If the token expires, the generator stops and no preview changes.
- Set `goTemplate: true` and `goTemplateOptions: ["missingkey=error"]`, so that a wrong parameter name fails.

### Isolation

- Use one namespace per environment, for example `preview-{{.number}}`.
- Put the preview Applications in their own AppProject. Limit the destinations and do not allow cluster-scoped resources.
- Add a NetworkPolicy that denies all traffic and allows only DNS and the services that the application needs.
- Add a ResourceQuota and a LimitRange to each namespace. Include object counts, for example Secrets and Services.

### Secrets

- The code in a merge request is not reviewed yet. Do not give it production credentials.
- Use a namespaced SecretStore with non-production, short-lived credentials.
- If you use a ClusterSecretStore, limit it with `conditions` to the namespaces that need it.

### Cleanup

- ArgoCD does not delete a namespace that `CreateNamespace=true` created. Put the Namespace in the manifests, so that ArgoCD prunes it.
- Keep `preserveResourcesOnDeletion` at its default value `false`. If you change it, set it in `spec.syncPolicy`, not in `syncOptions`.
- If a merge request still matches the generator, ArgoCD creates a deleted Application again. Remove the label to delete it.
- Do not trust only the close event. Add a scheduled job that deletes preview namespaces older than a TTL, for example 72 hours.
- Label each preview namespace, for example `preview=true`. The scheduled job deletes only namespaces with that label and a valid `preview-` name.
- ArgoCD deletes only Kubernetes resources. The pipeline must delete external resources, for example DNS records or databases.
