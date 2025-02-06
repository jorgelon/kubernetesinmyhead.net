# Karpenter disruption

There are several ways to delete a kubernete node.

## Manual deletion

When Karpenter deploys a node it adds a kubernetes finalizer **karpenter.sh/termination** to the node.

- Node
A node can be manually deleted by a user or by an external system. When a **node without this finalizer is deleted** (via kubectl or api call), the instance will not be deleted from AWS EC2. It is only unregistered from the kubernetes cluster. All the containing pods will deleted by a gargage collection and they will start in another node.
This karpenter finalizer **improves** the deletion process.

- Nodeclaim
The karpenter nodes are associated to a nodeclain. **Deleting the nodeclain** also deletes the node.

- Nodepool
The nodepools are the owners of the nodeclaims (ownerReferences). If a **nodepool is deleted**, the associated nodeclaims and nodes will be deleted.

## Automatic graceful methods: Consolidation

With this method karpenter tries to reduce the cluster cost deleting nodes or replacing them.

### consolidationPolicy

Karpenter can delete nodes:

- when the node is empty. This is when it has no daemonset related pods running. (deletion mechanism)
- when the workloads can run in another nodes. (deletion mechanism)
- when the nodes can be replaced with cheaper variants. (replace mechanism)

There are 2 consolidation policies: WhenEmptyOrUnderutilized (default) and WhenEmpty and it can be specified in **spec.disruption.consolidationPolicy** of the nodepool.

The order of the actions that the consolidation tries to do is:

- delete all the empty nodes in parallel
- delete 2 or more nodes and possibly creating a new one if this is a cheaper solution
- delete a single node and possibly creating a new one if this is a cheaper solution

> Nodes with fewer pods, or with upcoming expiration or with lower priority pods will be better candidates to be consolidated

Things like the anti-affinity, pod disruption budgets or topology spreads affects the effectiveness of the consolidation

### Spot to spot consolidation

The spot nodes are consolidated by default with the deletion mechanism.

It is possible to enable the replace one through the SpotToSpotConsolidation feature flag karpenter considers another things in addition to the cheapest price. It also needs a minimum of 15 instance types to work and possibility to be interrupted is also observed.

### consolidateAfter

When a pod is added or deleted from a node, karpenter starts to calculate if the node is consolidatable when the value specified in **spec.disruption.consolidateAfter** is reached. With this we can tell karpenter to be more cautious or aggressive in terms of consolidation.

> We can disable the consolidation with the "Never" value here

## Automatic graceful methods: Drift

The drift method tries to reconciliate the desired state of the nodepools and ec2nodeclasses with the actual one.
In order to check if there is a drift, karpenter compares some fields in that resources. It also maintains some hashes in the resources.

## Automated forceful methods: Expiration

It is possible to expire nodes with the **spec.template.spec.expireAfter** field. The default vale is 720 hours (30 days)

## Automated forceful methods: Interruption

When this methods karpenter watch some events that can cause involuntary interruptions.

- AWS will reclaim an spot instance
- Maintenance tasks
- Instance deletion events
- Instance stopping events

Then karpenter sends a drain, taint and deletion of the node.

> With the spot interruption warnings, there are 2 minutes to solve the situation. In order to get the events we need to configure an sqs queue and a some EventBridge rules. Also, by default, karpenter does not manage the **Spot Rebalance Recommendations**.

## Methods to control the disruptions

### Nodepool TerminationGracePeriod

The **spec.template.spec.terminationGracePeriod** in a nodepool sets the time a node can be in a draining state before being forcibly deleted. Changing this value in the nodepool **will drift** the nodeclaims.

During this time, the pods are being deleted based on the **terminationGracePeriodSeconds** pods setting until terminationGracePeriod in the nodepool reaches, so it can be a good practice to set the terminationGracePeriod with a greater value than the higher terminationGracePeriodSeconds. With this command we can get the 5 higher terminationGracePeriod setting in all the pods of the cluster:

```shell
kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.terminationGracePeriodSeconds}{"\n"}{end}' | sort -k 2,2n | tail -5
```

> Warning. This command does not makes a relation between the pod and the nodepool where it is deployed

### Nodepool Disruption Budgets

With **spec.disruption.budgets** we can control the speed of the disruption defining budgets. In a budget we can set some filters and settings:

- nodes:
Limit the maximum nodes of the nodepool that can be deleted at the same time. It can be an number or a percentage.
A "0" value disables the disruption for this budget.

- reasons:
This budget applies to nodes that they are being disrupted for the specified reasons. The possible values are Empty, Drifted and Underutilized

- schedule:
Cron like schedule when this budget applies

- duration:
It is a **needed setting when using schedule**. It defines the time this budget is active when the schedule starts.

> By default, there is only a budget with nodes: 10%

### Exclude pod from being disrupted

The following pod annotation protects it from being deleted by karpenter, what also blocks the deletion of the node that pod is located.

```txt
karpenter.sh/do-not-disrupt: "true"
```

### Exclude node from being disrupted

The same annotaion can protect a node from being deleted by karpenter.

```txt
karpenter.sh/do-not-disrupt: "true"
```
