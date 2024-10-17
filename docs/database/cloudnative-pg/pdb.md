# CloudnativePG, PDB and draining nodes

<https://github.com/cloudnative-pg/cloudnative-pg/issues/5299>

When a node is cordoned, Kubernetes creates a taint on the node and marks it as unschedulable. This prevents new pods from being scheduled on the node.

We can see the taint in a cordoned node

```yaml
spec:
  taints:
  - effect: NoSchedule
    key: node.kubernetes.io/unschedulable
  unschedulable: true
```

By default, Cloudnative PG creates a pod disruption budget to protect the primary instance. If the node where the primary instance is cordoned, the operator will try to find a replica in another node and then promote it to primary.
Once the promotion has been done, the former primary can be evicted with a drain.

It is easy to check this behaviour. Simply cordon the node where the replica is, and see the logs in the controller. We can get this kind of messages.

```txt
Primary is running on an unschedulable node, will try switching over
```

If all the replicas are in not ready nodes, the pdb will continue blocking the drain operations.

```txt
Current primary is running on unschedulable node, but there are no valid candidates
```

In that situation, we must move a replica to another node an let the controller do a promotion. A good practice can be to create antiaffinity to deploy every replica in different nodes.

That pdb creation can be disabled via spec.enablePDB in the cluster resource.

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: mycluster
spec:
  enablePDB: false
```

{"level":"info","ts":"2024-10-17T10:40:05Z","msg":"Primary is running on an unschedulable node, will try switching over","controller":"cluster","controllerGroup":"postgresql.cnpg.io","controllerKind":"Cluster","Cluster":{"name":"cnpg-infisical","namespace":"infisical"},"namespace":"infisical","name":"cnpg-infisical","reconcileID":"a746d22c-2c84-4eea-8925-72aa20f5b510","node":"hyper-testing02.bosonit.local","primary":"cnpg-infisical-2"}
{"level":"info","ts":"2024-10-17T10:40:05Z","msg":"Current primary is running on unschedulable node and something is already in progress","controller":"cluster","controllerGroup":"postgresql.cnpg.io","controllerKind":"Cluster","Cluster":{"name":"cnpg-infisical","namespace":"infisical"},"namespace":"infisical","name":"cnpg-infisical","reconcileID":"a746d22c-2c84-4eea-8925-72aa20f5b510","currentPrimary":"cnpg-infisical-2","podsOnOtherNodes":0,"instances":2,"readyInstances":2,"primaryNode":"hyper-testing02.bosonit.local"}
{"level":"info","ts":"2024-10-17T10:40:06Z","msg":"Primary is running on an unschedulable node, will try switching over","controller":"cluster","controllerGroup":"postgresql.cnpg.io","controllerKind":"Cluster","Cluster":{"name":"postgre","namespace":"realm-import"},"namespace":"realm-import","name":"postgre","reconcileID":"79ce92d9-da27-4402-9252-b51350116e72","node":"hyper-testing02.bosonit.local","primary":"postgre-1"}
{"level":"info","ts":"2024-10-17T10:40:06Z","msg":"Current primary is running on unschedulable node, but there are no valid candidates","controller":"cluster","controllerGroup":"postgresql.cnpg.io","controllerKind":"Cluster","Cluster":{"name":"postgre","namespace":"realm-import"},"namespace":"realm-import","name":"postgre","reconcileID":"79ce92d9-da27-4402-9252-b51350116e72","c

The operator checks nodes for this information. If a primary database is running on a node that has been cordoned, the operator will promote a secondary on another node. This allows the cordoned node to be evicted without blocking the process due to the PDB of the primary.

Kubernetes uses the "node.kubernetes.io/unschedulable" taint and the "spec.unschedulable" field on a node to mark it as cordoned. The operator checks nodes for this information.
If a primary database is running on a node which was cordoned the operator will promote a secondary on another node.
This allows to evict the cordoned node without blocking the process due to the PDB of the primary.
