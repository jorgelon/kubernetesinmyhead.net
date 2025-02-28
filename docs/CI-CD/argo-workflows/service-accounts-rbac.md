# Service accounts and rbac

## Argo workflows

All the pods in a workflow use a service account. This service account can be specified with spec.serviceAccountName in the workflow. If not, uses the "default" service account (not recommended).

> If using the argo cli, we can achieve that with the --serviceaccount NAME parameter

```shell
argo submit --serviceaccount myserviceaccount myworkflow
```

The minimum permissions to run workflows in newest releases (since 3.4) is:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: executor
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: executor
rules:
  - apiGroups:
      - argoproj.io
    resources:
      - workflowtaskresults
    verbs:
      - create
      - patch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: executor
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: executor
subjects:
  - kind: ServiceAccount
    name: executor
    namespace: argo
```

> Depending of what the workflow has to do, it will neccesary to give that service account additional permissions via kubernetes rbac. For example, if the workflow creates pods, it will need the verb "create" in pods resource.

### Using the http template

See the [http template doc](templates/http.md)

### Workflow links

- Argo workflows service accounts  
<https://argo-workflows.readthedocs.io/en/stable/service-accounts/>

- Argo workflows rbac
<https://argo-workflows.readthedocs.io/en/stable/workflow-rbac/>

## In an Argo events sensor

If you want to create a workflow using an argo events sensor, you can pass the name of the service account (and other arguments) to the argo cli with the field "args" in addition to "source", "parameters" and "operation".

- Argo workflows trigger spec in Argo events
<https://github.com/argoproj/argo-events/blob/master/api/sensor.md#argoproj.io/v1alpha1.ArgoWorkflowTrigger>
