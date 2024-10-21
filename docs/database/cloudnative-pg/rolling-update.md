# Rolling update a cluster

There are several reasons we can do some changes in a cloudnative pg cluster that requires a rolling update in the cluster, this is, recreate the postgresql pods with the new settings.

- Updates in the operator
- Changes in the spec.image field or in the image catalog
- Changes in the postgresql configuration
- Changes in spec.resources
- Changes in the postgresql configuration
- Changes in the size of the persistent volume

> There is a way to not trigger a rolling update when the operator is updated called "In-place updates of the instance manager". But it is not a clean way to do it.

When a rolling update is triggered, the operator upgrades the replicas, but how the primary instance will be updates can be configured

## primaryUpdateStrategy

spec.primaryUpdateStrategy defines if we want to control the update the of primary instance.

- unsupervised (default)
The update is automatic based in the spec.primaryUpdateMethod field (see below)

- supervised
This is the manual update to the primary.

## primaryUpdateMethod

spec.primaryUpdateMethod defines how we want to update the primary instance and it is applied when the primaryUpdateStrategy is "unsupervised". We have 2 options here:

- restart (default)
This restarts the primary replica

- switchover
A switchover is triggered to the most aligned replica. Then, the former primary is updated.

> There is not a best practice here and a lot of circumstances can make one or other option the best.
