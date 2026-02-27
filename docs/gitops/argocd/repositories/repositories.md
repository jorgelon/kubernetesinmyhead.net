# Repositories

Repositories tell ArgoCD where to read the content used to deploy applications.

ArgoCD supports two types of repositories:

- **Git** — plain manifests, Kustomize, or Helm values stored in Git
- **Helm** — classic HTTP/S chart repositories or OCI registries

> A Git repo can reference external Helm chart repositories without registering
> them as a Secret — unless authentication is required.

## Declarative definition

Repositories are Kubernetes Secrets labelled with
`argocd.argoproj.io/secret-type: repository`. ArgoCD watches for that label
and registers the repository automatically.

Supported authentication methods per type:

- **Git HTTPS** — `username` + `password` (or personal access token)
- **Git SSH** — `sshPrivateKey`
- **Helm HTTP/S** — `username` + `password`, optional TLS client cert fields

## Credential templates

When many repositories share the same credentials, use a **credential template**
instead of repeating secrets per repo. The label changes to `repo-creds` and
the `url` acts as a prefix matcher.

> A Secret with its own credentials **will not** inherit from a matching template.

## Project-scoped repositories

A repository can be bound to an ArgoCD project by adding the `project` field.

### With project field vs without

| | Global (no `project` field) | Project-scoped (`project` field set) |
|---|---|---|
| **Visibility** | Available to all projects | Only the named project can use it |
| **`sourceRepos` required** | Yes — must be listed in the AppProject | No — implicitly allowed for that project |
| **Credentials** | Listed in Secret or via `repo-creds` template | Same, but the repo is invisible to other projects |
| **Self-service** | Admin adds it once, all projects can reference it | Developers can manage their own repos (with RBAC) |
| **ApplicationSet** | Usable from any project | Only by AppSets whose `project` matches; templated `project` fields (e.g. `{{ project }}`) require a global repo |

**When to use project-scoped repos:**

- The repository belongs to a single team and must not be accessible to others.
- Delegate repo management to developers via RBAC (`create/update/delete` on
  `repositories` scoped to the project namespace).

**When to keep repos global:**

- Shared Helm chart repositories referenced by multiple projects.
- ApplicationSets that template the `project` field dynamically — these can
  only consume non-scoped repositories.
- Credential templates (`repo-creds`) are always global; there is no
  project-scoped credential template concept.

## Links

- [Private repositories](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/)
- [Repository security](https://argo-cd.readthedocs.io/en/stable/operator-manual/security/#git-helm-repositories)
- [Project-scoped repositories and clusters](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/#project-scoped-repositories-and-clusters)
- [Declarative setup — repositories](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repositories)
- [Repository credential templates](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#repository-credentials)
- [Repository examples YAML](https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repositories-yaml/)
- [Repo-creds examples YAML](https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-repo-creds-yaml/)
