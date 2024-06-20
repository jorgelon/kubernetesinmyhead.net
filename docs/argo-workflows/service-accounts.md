# Service accounts en workflows

## Argo workflows

Argo workflows needs to access kubernetes like artifacts, secrets, outputs,...
By default, argo uses the default service account of the namespace where the workflow has been created. But this is not recommended to run in production, so it is a best practice to create a new service account and use it in the spec.serviceAccountName field of the workflow.

> If using the argo cli, we can achieve that with the --serviceaccount NAME parameter

```shell
argo submit --serviceaccount myserviceaccount myworkflow
```

The minimum permissions to run workflows in newest (since 3.4) releases is:

```yaml
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
```

Depending of what the workflow has to do, it will neccesary to give that service account additional permissions via kubernetes rbac. For example, if the workflow creates pods, it will need the verb "create" in pods resource.

## In an Argo events sensor

If you want to create a workflow using an argo events sensor, you can pass the name of the service account (and other arguments) to the argo cli with the field "args" in addition to "source", "parameters" and "operation".

## Links

- Argo workflows service accounts  
<https://argo-workflows.readthedocs.io/en/stable/service-accounts/>

- Argo workflows rbac
<https://argo-workflows.readthedocs.io/en/stable/workflow-rbac/>

- Argo workflows trigger spec in Argo events
<https://github.com/argoproj/argo-events/blob/master/api/sensor.md#argoproj.io/v1alpha1.ArgoWorkflowTrigger>

- Service accounts in Argo events:  
[Link](../argo-events/service-accounts.md)
