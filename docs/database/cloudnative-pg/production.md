# CNPG in production

## Deployment

- Use gitops tools (argocd, flux,...) to control the deployment
- Use gitops tools like external-secrets operator to control the credentials
- You can enable the spec.monitoring.enablePodMonitor setting and setup a monitoring and alerting system

## Configuration

- Always setup a backup section in our clusters and review the status of the backups
- Try not to enable spec.enableSuperuserAccess. You can create additional roles with the needed permissions.
- Configure the primaryUpdateStrategy
- Define the resources (requests and limits in the cluster)
- Give the postgresql pods a higher priority class
- Leave spec.enablePDB enabled (default)
- Use odd replicas (3, 5, ...)
- Configure the affinity section to distribute the instances in nodes
- Consider to use dedicated and/or performance nodes in the the postgresql instances

## Karpenter and cluster autoescaler

Until 1.26 release, cloudnative-pg only detects a node is being drained if detects via the node.kubernetes.io/unschedulable taint

Since 1.26 release, cloudnative-pg detects a node is being drained with these taints:

- node.kubernetes.io/unschedulable
- ToBeDeletedByClusterAutoscaler
- karpenter.sh/disrupted
- karpenter.sh/disruption

When karpenter and cluster autoscaler taints the node, the controller knows the node will be delete and it can initiate a failover
