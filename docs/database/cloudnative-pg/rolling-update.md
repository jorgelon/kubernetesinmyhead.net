# Rolling update a cluster

## Reasons

There are several reasons we can do some changes in a cloudnative pg cluster that requires a rolling update in the cluster, this is, recreate the postgresql pods with the new settings:

- Updates in the operator (*)
- Changes in the spec.image field or in the image catalog
- Changes in spec.resources
- Changes in the postgresql configuration
- Changes in the size of the persistent volume

> (*) There is a way to not trigger a rolling update when the operator is updated called "In-place updates of the instance manager". But it is not a clean way to do it.

When a rolling update is triggered, the operator upgrades the replicas, but how the primary instance will be updates can be configured

## primaryUpdateStrategy

spec.primaryUpdateStrategy defines if we want to control the update the of primary instance.

- unsupervised (default)
The update is automatic based in the spec.primaryUpdateMethod field (see below)

- supervised
This is the manual update to the primary and suspends the update of the primary. In order to continue we can manually do the switchover or the restart of the primary.

## primaryUpdateMethod

spec.primaryUpdateMethod defines how we want to update the primary instance and it is applied when the primaryUpdateStrategy is "unsupervised". We have 2 options here:

- restart (default)
This restarts the primary replica

- switchover

A switchover operation is triggered. In the switchover operation the former primary will be shut down.
The **spec.switchoverDelay** can be expressed in seconds as the time to give to the primary to shutdown gracefully and archive the wal files. The default value is 3600 (1h).

- RTO (recovery time objective) is the time between the failure and when the service is up again.
- RPO (recovery point objective) is more related with the amount of data loss

A lower **spec.switchoverDelay** gives priority to reduce the time (RTO) and a higher value reduces the risk of data loss (RPO).

Then, the most aligned replica is promoted as the new primary.

> Again this value is a decision to take depending of several reasons like the environment or workload. In all cases a rolling update causes a service loss.
