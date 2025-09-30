# ApplicationSet Not Found UI Error

## Problem Description

After upgrading ArgoCD from 2.x to 3.x, non admin users with project-scoped permissions see this error in the UI:

```txt
Unable to load data: ApplicationSet XXX not found in any namespace
```

## Root Cause

In argocd 3.0 a RBAC change was introduced.

Prior to argocd v3.0, policies granting update and delete to applications also applied to sub-resources (like ApplicationSet
Starting with v3.0, update and delete actions **only apply to the application itself**.
ArgoCD 3.0+ disabled permission inheritance by default, requiring explicit permissions for each resource type.

The ArgoCD UI tries to load ApplicationSet information when displaying applications (for context/breadcrumbs), but users lack the necessary permissions.

Notes

- This is a **UI display issue**, not a functional problem
- **Admin users** are not affected (they have global permissions)

## Solutions

- Restore old behaviour

It is possible to enable the previous behaviour with this setting in the argocd-cm configmap

```yaml
server.rbac.disableApplicationFineGrainedRBACInheritance: "false"
```

**⚠️ Warning**: This affects all RBAC inheritance behavior, not just ApplicationSets.

- Add Explicit ApplicationSet Permissions (Recommended)

Another option is to give minimal ApplicationSet permissions

```yaml
p, proj:MYPROJECT:MYROLE, applicationsets, get, PROJECT/*, allow
```

Testing

```bash
argocd account can-i get applicationsets 'PROJECT/*'
```

## Related Issues

- [GitHub Issue #23571: ApplicationSet not found Toast](https://github.com/argoproj/argo-cd/issues/23571)
- [ArgoCD 3.0 Migration Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.14-3.0/)
- [ApplicationSet Security Documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Security/)
