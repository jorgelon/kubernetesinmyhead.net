# Sync

Argocd in their documentation defines 2 states for an argocd application:

- The target state, as the desired state of the application.
We define this state via files in git repositories

- The live state

The real state is how the application is the kubernetes cluster

> Sync is the argocd process that applies the manifests in the cluster.

## Sync statuses

We have 3 possible sync statuses

- Synced

The target state and the live state are the same. Everything is ok.

![alt text](../img/synced.png)

- OutOfSync

There are differences between the target state and the live state. Sometimes a Sync is needed to move this state to Synced

![alt text](../img/outofsync.png)

- Unknown

There is a problem with the Sync process

> See the other links in this section for more information
