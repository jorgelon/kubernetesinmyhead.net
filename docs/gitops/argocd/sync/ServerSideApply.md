# ServerSideApply

There are 2 ways to apply manifests in kubernetes. Client-Side and Server-Side

## Client-Side Apply in kubernetes

By default kubectl apply uses the traditional client-side way.

## Server-Side Apply in kubernetes

- Server-Side

It became GA in kubernetes 1.22 as a new object merge algorithm, as well as tracking of field ownership, running on the Kubernetes API server.

Server-Side Apply allows multiple "managers" (e.g., ArgoCD, kubectl, other controllers) to declaratively manage different parts of a resource's configuration.
Each manager owns specific fields in the resource's manifest.
The Kubernetes API server tracks which manager owns which fields in the resource's spec. This is called field ownership.
When a manager applies changes, only the fields it owns are updated, leaving fields owned by other managers untouched.
If two managers attempt to modify the same field, the API server detects the conflict and rejects the change unless explicitly forced.

To see what "manager" controls what fields we can use this:

```shell
kubectl get RESOURCE RESOURCENAME --show-managed-fields -o yaml
```

## ServerSideApply in argocd

When to enable it

- When the resource exceeds the 262144 bytes allowed in the annotations. This error can be found in some big CRDs.

- When Patching of existing resources on the cluster that are not fully managed by Argo CD.

- Use a more declarative approach, which tracks a user's field management, rather than a user's last applied state.

- Improved Merge Behavior:

Server-Side Apply ensures that changes made by other tools or controllers (e.g., Horizontal Pod Autoscaler, custom controllers) are not overwritten by ArgoCD unless explicitly managed by ArgoCD.
This is particularly useful in scenarios where multiple tools manage the same resource.

- Conflict Detection:

ArgoCD will detect and report conflicts if another manager modifies fields that ArgoCD is trying to manage. This prevents accidental overwrites and ensures better collaboration between tools.

- Declarative Ownership:

ArgoCD explicitly declares ownership of specific fields in the resource manifest. This makes it easier to understand which tool is responsible for managing which parts of a resource.

- Compatibility with Kubernetes Features:

Server-Side Apply is required for certain Kubernetes features, such as managing CRDs (Custom Resource Definitions) or advanced controllers that rely on field ownership.

- Potential for Conflicts:

If not carefully managed, enabling Server-Side Apply can lead to conflicts when multiple tools or users attempt to manage the same fields in a resource.
Performance:

Server-Side Apply shifts the responsibility of merging changes to the Kubernetes API server, which can reduce the load on ArgoCD but may slightly increase the load on the API server.

## Enable ServerSideApply in argocd

- At Application controller level

We can enable server side apply with the param **--server-side-diff-enabled** in the argocd-application-controller, or with the following setting in the argocd-cmd-params-cm configMap

```yaml
controller.diff.server.side: true # false by default
```

Enables the server side diff feature at the application controller level. Diff calculation will be done by running a server side apply dryrun (when diff cache is unavailable)

- At application level

## Links

- Server-Side Apply

<https://kubernetes.io/docs/reference/using-api/server-side-apply/>

- Server-Side Apply support for ArgoCD (proposal)

<https://argo-cd.readthedocs.io/en/stable/proposals/server-side-apply/>

- ServerSideApply argocd sync option

<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/#server-side-apply>
