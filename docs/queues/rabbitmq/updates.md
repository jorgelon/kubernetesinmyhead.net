# Updates

We can do 2 updates if we are using the rabbitmq cluster kubernetes operator:

- Update the operator
- Update the cluster

## Operator

In order to update the operator we only need to update the manifest to the desired releases. All the releases are located here:

<https://github.com/rabbitmq/cluster-operator/releases>

The latest version of the operator is located here:

<https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml>

Sometimes updating the rabbitmq kubernetes operator also updates the pods of the cluster:

- If we are not using spec.image in the definition of the cluster, we are using the default rabbitmq container image. The new release of the operator will probably have a newer default rabbitmq container image, but the operator update will maintain the previous one in exiting clusters. Newer clusters without spec.image will use the new default one.

- It is possible that updating the operator changes another fields of the podSpec so the pods will be restarted.

A good workaround can be pause the reconciliation, upgrade the operator, resume the reconciliation when you decide to do it

> To know the default rabbitmq release the operator deploys and if it will cause a restart of the pods, see the changelog

## Pause the reconciliation

In order to pause the reconciliation we need to add this label to the cluster

```txt
rabbitmq.com/pauseReconciliation: true
```

## Links

- Upgrading the RabbitMQ Kubernetes Operators

<https://www.rabbitmq.com/kubernetes/operator/upgrade-operatorhttps://www.rabbitmq.com/kubernetes/operator/upgrade-operator>

- Pause Reconciliation for a RabbitMQCluster

<https://www.rabbitmq.com/kubernetes/operator/using-operator#pause>
