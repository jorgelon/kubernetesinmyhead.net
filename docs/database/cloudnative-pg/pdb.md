# CloudnativePG, PDB and draining nodes

When a node is cordoned, Kubernetes creates a taint on the node and marks it as unschedulable. This prevents new pods from being scheduled on the node.

We can see the taint in a cordoned node

```yaml
spec:
  taints:
  - effect: NoSchedule
    key: node.kubernetes.io/unschedulable
  unschedulable: true
```

By default, Cloudnative PG creates a pod disruption budget with no allowed disruptions to protect the primary instance. If the node where the primary instance is cordoned, the operator will try to find a replica in another node and then promote it to primary. Once the promotion has been done, the former primary can be evicted with a node drain.

It is easy to check this behaviour. Simply cordon the node where the replica is, and see the logs in the controller. We can get this kind of messages.

```txt
Primary is running on an unschedulable node, will try switching over
```

If all the replicas are in not ready nodes, the pdb will continue blocking the drain operations.

```txt
Current primary is running on unschedulable node, but there are no valid candidates
```

In that situation, we must move a replica to another node an let the controller do a promotion, for example, with a restart with cnpg cli. A good practice can be to setup the anti-affinity in the cluster resource to ensure every replica in deployed in different nodes.

## Disabling

That pdb creation can be disabled via spec.enablePDB in the cluster resource. This feature is available since the v1.23.0 release.

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: mycluster
spec:
  enablePDB: false
```

## Karpenter

There is a problem with karpenter and this behaviour. Karpenter knows there is pdb in the node with no allowed disruption and the node will not be disrupted.

You can get events like this

```txt
DisruptionBlocked
Cannot disrupt Node: pdb "mynamespace/mycluster-primary" prevents pod evictions
```

In order to permit a node to be disrupted by karpenter you must move the primary instaces to another nodes
