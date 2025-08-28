# Disruption

Karpenter's disruption is the process that makes Karpenter terminates nodes in the Kubernetes cluster.

## Planning phase (disruption controller)

### Search candidates

The disruption controller is continuously discovering nodes that can be disrupted because of this reasons:

- drift
- consolidation (empty)
- consolidation (underutilized)

> The number of candidates per reason is located in the karpenter_voluntary_disruption_eligible_nodes prometheus metric

First, the disruption controller starts **searching for candidates for a drift disruption** and it gives them priorities. If a node in that list has pods that cannot be evicted from the node, the node is ignored for now.

The disruption can be blocked here because of:

- Pod disruption budgets

Pods in the node affected by disruption buckets with 0 ALLOWED DISRUPTIONS

- karpenter.sh/do-not-disrupt

Pods in the node with karpenter.sh/do-not-disrupt: "true" annotation. If the nodeclaim has **terminationGracePeriod** configured, it will still be eligible for disruption via drift.

We can see that blocked nodes with

```shell
kubectl get events --all-namespaces --field-selector involvedObject.kind=Node | grep DisruptionBlocked
```

If no nodes cannot be disrupted, the **same process will start with the consolidation disruption**.

### Evaluate candidates

- NodePool’s disruption budget

The next step is to check the if the node respect the NodePool’s disruption budget, a mechanism to control the speed of the disruption process.

- Evaluate if new nodes are needed

Then the disruption controller does a simulation to estimate if any replacement nodes are needed.

### Taint the nodes

Next, the chosen node(s) are tainted with **karpenter.sh/disrupted:NoSchedule** to prevent new pods being scheduled there.

### Deploy replacement nodes

If new replacement nodes are needed, the disruption controller triggers their deployment and wait until they are deployed. If the deployment fails, the node(s) is(are) untainted and the whole process starts again.

### Node deletion

Here the disruption controller deletes the node. All the Nodes and NodeClaims deployed via Karpenter have a kubernetes finalizer **karpenter.sh/termination**.  So the the deletion is blocked leaves that task to the termination controller.

> When the termination controller terminates the node, the whole process starts again.

## Execution phase (termination controller)

The termination controller is responsible to finally delete the node. The deletion if blocked by the finalizer. This deletion can be triggered by:

- the disruption controller
- a user using manual disruption
- an external system that deletes the node resource

> The APIServer has added the DeletionTimestamp on the node

### Taint

The chosen node(s) is(are) tainted with **karpenter.sh/disrupted:NoSchedule** to prevent new pods being scheduled there. Depending of the disruption method, that taint can exist.

### Eviction

The termination controller starts evicting the pods using the Kubernetes Eviction API.

- This respects Pod disruption budgets
- Static pods, pods tolerating the karpenter.sh/disrupted:NoSchedule taint, and succeeded/failed pods are ignored

### Cleaning

- When the node is drained, the NodeClaim is deleted
- Finally the finalizer is removed from the node so the APIServer can remove it

## Forceful deletion

In **expiration and interruption methods** the disruption controller immediately triggers tainting and draining as soon as the event is detected (interruption signal or expireAfter).

- That methods do not respect NodePool’s disruption budget.
- Pod disruption budgets can be used to control the disruption speed at application level.
- That methods they do not wait for a replacement node to be healthy
