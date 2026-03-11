# Authorization with RBAC

Once a user, group, or service account is authenticated against the Kubernetes API, authorization takes effect.
Kubernetes supports several authorization modules enabled at the API server level. RBAC (Role-Based Access Control)
is the standard one.

> RBAC only grants permissions — it cannot deny them. By default, users, groups, and service accounts have no
> permissions, so RBAC is the mechanism to grant them.

## Concepts

### Role

A `Role` is a namespaced resource that contains a set of rules defining access to namespaced resources within the
same namespace where the Role was created.

### ClusterRole

A `ClusterRole` is a cluster-scoped resource that can be referenced across all namespaces. It can serve three
purposes:

- Grant access to cluster-scoped resources (e.g. nodes, namespaces)
- Grant access to namespaced resources within a specific namespace
- Grant access to namespaced resources across all namespaces

> The key difference between a Role and a ClusterRole is that a Role can only be referenced by a RoleBinding in
> the same namespace where it was created.

To list namespaced resource types:

```shell
kubectl api-resources --namespaced=true
```

To list cluster-scoped resource types:

```shell
kubectl api-resources --namespaced=false
```

### RoleBinding

A `RoleBinding` is a namespaced resource that associates a Role or a ClusterRole with one or more subjects
(users, groups, or service accounts), granting permissions within a specific namespace.

- A RoleBinding may reference any Role in the same namespace.
- A RoleBinding can also reference a ClusterRole, binding it to the namespace of the RoleBinding.

The spec uses `subjects` for the users/groups/service accounts and `roleRef` for the Role or ClusterRole.

### ClusterRoleBinding

A `ClusterRoleBinding` is a cluster-scoped resource that associates a ClusterRole with subjects, granting
permissions across all namespaces in the cluster.

## When to use each

| Goal | Resource |
|------|----------|
| Permissions scoped to one namespace, not reusable elsewhere | `Role` + `RoleBinding` |
| Reusable permissions applied to one namespace | `ClusterRole` + `RoleBinding` |
| Permissions applied cluster-wide | `ClusterRole` + `ClusterRoleBinding` |

## Links

- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Role spec](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/role-v1/)
- [ClusterRole spec](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/cluster-role-v1/)
- [RoleBinding spec](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/role-binding-v1/)
- [ClusterRoleBinding spec](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/cluster-role-binding-v1/)
