# spotToSpotConsolidation

spotToSpotConsolidation is a karpenter feature (alpha since v0.34.x) that permits to replace existing Spot Instances with new Spot Instances that are more cost-effective or better suited to your workloads.

spotToSpotConsolidation is disabled by default because increases the risk of workload interruptions because it can increase the termination and creation of spot instances.
By keeping it disabled by default, Karpenter ensures a more stable and predictable environment.

It is an aggresive way to optimize costs and be more resource effective

> In 1 node to 1 node consolidations, Karpenter requires at least 15 different instance types  a minimum instance type flexibility of 15 candidate instance types. flexibility won’t lead to “race to the bottom” scenarios.

## Recommended environments

This situations make spotToSpotConsolidation a good option

- Clusters with high tolerance to interruptions
- Non production clusters
- Environments where Spot Instance prices fluctuate frequently

To make a cluster more interruption tolerant, there are features like Pod Disruption Budgets or graceful termination hooks

## Non recommended environments

- Production clusters

Test it in non production clusters first

- The workloads are stateful

Stateful applications (e.g., databases, message queues) are not ideal for frequent Spot Instance replacements. Moving them to on demand nodes can be a good practice

- Ha apps

If your workloads require consistent availability and cannot tolerate interruptions, this feature may introduce unnecessary risk.

- Spot Market Is Unstable

In regions or zones where Spot Instance availability is highly volatile, frequent consolidations may lead to excessive disruptions.

## How to enable

It is a feature flag / gate. To enable it via helm, we need this

```yaml
settings:
  featureGates:
    spotToSpotConsolidation: true
```

## Links

- Disruption

<https://karpenter.sh/docs/concepts/disruption/>

- Applying Spot-to-Spot consolidation best practices with Karpenter  

<https://aws.amazon.com/blogs/compute/applying-spot-to-spot-consolidation-best-practices-with-karpenter/>
