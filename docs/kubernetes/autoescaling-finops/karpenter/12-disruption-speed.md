# Disruption speed

## Nodepool TerminationGracePeriod

The **spec.template.spec.terminationGracePeriod** in a nodepool sets the time a node can be in a draining state before being forcibly deleted. Changing this value in the nodepool **will drift** the nodeclaims.

During this time, the pods are being deleted based on the **terminationGracePeriodSeconds** pods setting until terminationGracePeriod in the nodepool reaches, so it can be a good practice to set the terminationGracePeriod with a greater value than the higher terminationGracePeriodSeconds. With this command we can get the 5 higher terminationGracePeriod setting in all the pods of the cluster:

```shell
kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.terminationGracePeriodSeconds}{"\n"}{end}' | sort -k 2,2n | tail -5
```

> Warning. This command does not makes a relation between the pod and the nodepool where it is deployed

## Nodepool Disruption Budgets

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
