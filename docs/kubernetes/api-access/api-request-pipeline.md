# Kubernetes API Request Pipeline

Every request to the Kubernetes API server goes through a series of phases before a resource is created,
modified, or read. Understanding this pipeline gives you a mental model of how access control and validation
work end to end.

```text
Client → [Authentication] → [Authorization] → [Admission Control] → etcd
```

## 1. Authentication

The API server first identifies **who** is making the request. Kubernetes supports multiple authentication
strategies, all configured at the API server level:

- **X.509 client certificates**
- **Bearer tokens** (static, bootstrap, OIDC)
- **Service account tokens** (automatically mounted in pods)
- **Webhook token authentication** (delegates to an external service)

If no strategy can identify the requester, the request is treated as `system:anonymous`.

## 2. Authorization

Once the identity is known, the API server decides **whether** that identity is allowed to perform the
requested action on the requested resource.

Multiple authorization modules can be active at the same time. The request is allowed if **any** module
approves it (and none explicitly denies it):

- **RBAC** — role-based rules bound to users, groups, or service accounts. See [RBAC](authorization-with-RBAC.md).
- **ABAC** — attribute-based policies defined in a static file (rarely used)
- **Node** — special-purpose authorizer for kubelet requests
- **Webhook** — delegates the decision to an external HTTP service

## 3. Admission Control

After authorization, the request passes through **admission controllers** — plugins that can validate or
mutate the object before it is persisted:

- **Mutating admission webhooks** — can modify the object (e.g. inject sidecars, set defaults)
- **Validating admission webhooks** — can reject the object without modifying it (e.g. enforce policies)
- **Built-in controllers** — e.g. `LimitRanger`, `ResourceQuota`, `PodSecurity`

Admission control only applies to write operations (create, update, delete). Read requests skip this phase.

## 4. Persistence

If the request passes all phases, the object is written to **etcd** and the response is returned to the
client.
