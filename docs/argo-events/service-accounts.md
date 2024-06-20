# Service accounts

## For eventsources

The service account of an eventsource can be specified in the spec.template.serviceAccountName field of the eventsource but it does not requires special permissions. In addition to that it can be interesting to create a new one and not use the default one.

The exception is the "resource" eventsource. In that case you must give that service account the list and watch permissions to that resource being watched.

## For sensors

The service account of a sensor can be specified in the spec.template.serviceAccountName field of the eventsource but it does not requires special permissions. In addition to that it can be interesting to create a new one and not use the default one.

The exceptions are the k8s trigger adn the argoWorkflow trigger.

### Argo workflow trigger

To submit a workflow, the service account of the sensor needs create and list rbac permissions.
To resubmit, retry, resume or suspend a workflow, the service account of the sensor needs "update" and "get" rbac permissions.

Here it is a non tuned rbac permssions
<https://raw.githubusercontent.com/argoproj/argo-events/master/examples/rbac/sensor-rbac.yaml>

!!! Note "This rbac permissions are not related with what the workflow will do. Only for create, retry,... For that see [service accounts in argo workflows](../argo-workflows/service-accounts.md)

## K8s resource trigger

To create a kubernetes resource, the service account of the sensor needs "create" rbac permissions for that resource.

## Links

- Service Accounts in argo events  
<https://argoproj.github.io/argo-events/service-accounts/>
