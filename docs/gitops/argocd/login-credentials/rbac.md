# RBAC

RBAC controls what type of access a user has inside ArgoCD.

- Users can be local or SSO users
- There is a default builtin local user: `admin`
- RBAC configuration can be done globally via the `argocd-rbac-cm` ConfigMap or at AppProject level

## Default Builtin Roles

There are 2 default builtin roles (see [builtin-policy.csv](https://github.com/argoproj/argo-cd/blob/master/assets/builtin-policy.csv)):

- `role:readonly` — read-only access to all resources
- `role:admin` — unrestricted access to all resources

## Default Policy for Authenticated Users

The `policy.default` key in `argocd-rbac-cm` defines the role granted to every authenticated user.
All authenticated users get _at least_ the permissions granted by the default policy.
This access cannot be blocked by a `deny` rule.

It is recommended to set a minimal `role:authenticated` with the least permissions possible:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: role:readonly
  policy.csv: |
    p, role:org-admin, applications, *, */*, allow
    p, role:org-admin, clusters, get, *, allow
    g, my-org:team-alpha, role:org-admin
    g, user@example.org, role:admin
  scopes: '[groups, email]'
```

## Policy Syntax

The syntax in general is (`effect` is `allow` or `deny`)

```txt
p, <role/user/group>, <resource>, <action>, <object>, <effect>
```

### Application-Specific Resources

If the resource is applications, applicationsets, logs or exec, the syntax is different

```txt
p, <role/user/group>, <resource>, <action>, <appproject>/<object>, <effect>
```

| Resource          | get | create | update | delete | sync | override | action/... |
|-------------------|-----|--------|--------|--------|------|----------|------------|
| `applications`    | ✓   | ✓      | ✓      | ✓      | ✓    | ✓        | ✓          |
| `applicationsets` | ✓   | ✓      | ✓      | ✓      |      |          |            |
| `logs`            | ✓   |        |        |        |      |          |            |
| `exec`            |     | ✓      |        |        |      |          |            |

#### applications

The appproject is the ArgoCD project name. Also requires `get` on the project to view.
`override` + `sync` allow synchronizing local manifests to the Application.

```txt
p, role:dev, applications, get, my-project/*, allow
p, role:dev, applications, sync, my-project/my-app, allow
```

#### applicationsets

The appproject field represents the projects where the ApplicationSet can create Applications.

```txt
p, role:dev, applicationsets, create, my-project/*, allow
```

#### logs

Also requires `get` on the application to see Pod logs in the UI.

```txt
p, role:dev, logs, get, my-project/my-app, allow
```

#### exec

Allows exec into Pods via the ArgoCD UI.

```txt
p, role:dev, exec, create, my-project/my-app, allow
```

### Other Resources

```txt
p, <role/user/group>, <resource>, <action>, <object>, <effect>
```

| Resource       | get | create | update | delete |
|----------------|-----|--------|--------|--------|
| `clusters`     | ✓   | ✓      | ✓      | ✓      |
| `projects`     | ✓   | ✓      | ✓      | ✓      |
| `repositories` | ✓   | ✓      | ✓      | ✓      |
| `certificates` | ✓   | ✓      | ✓      | ✓      |
| `accounts`     | ✓   | ✓      | ✓      | ✓      |
| `gpgkeys`      | ✓   | ✓      | ✓      | ✓      |
| `extensions`   | ✓   | ✓      | ✓      | ✓      |

```txt
p, role:dev, repositories, get, *, allow
p, role:dev, clusters, get, *, allow
```

## Role and Group Bindings

```txt
g, <user/group>, <role>

g, my-org:team-beta, role:admin
g, user@example.org, role:admin
g, role:admin, role:readonly
```

The subject format depends on the authentication backend:

- Local user: `username`
- GitHub org team: `your-github-org:your-team`
- SSO group/ID: depends on the identity provider

## At AppProject Level

Policies can also be defined inside the `AppProject` resource using `spec.roles`.
The format uses `proj:PROJECT:ROLE` as the entity:

```txt
p, proj:my-project:my-role, applications, *, my-project/*, allow
```

## Links

- [RBAC Configuration](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/)
- [Global RBAC ConfigMap reference](https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-rbac-cm-yaml/)
- [AppProject Roles](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/#project-roles)
- [Configuring RBAC with Projects](https://argo-cd.readthedocs.io/en/stable/user-guide/projects/#configuring-rbac-with-projects)
- [Resource Actions](https://argo-cd.readthedocs.io/en/stable/operator-manual/resource_actions/)
