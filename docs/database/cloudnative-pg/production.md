# CNPG in production

## Deployment and observability

- Use gitops tools (argocd, flux,...) to control the deployment
- Use gitops tools like external-secrets operator to control the credentials
- You can enable the spec.monitoring.enablePodMonitor setting and setup a monitoring and alerting system

## Kubernetes Deployment

- Use odd replicas (3, 5, ...)
- Leave spec.enablePDB enabled (default)
- Configure the primaryUpdateStrategy
- Configure the affinity section to distribute the instances in nodes
- Consider to use dedicated and/or performance nodes in the the postgresql instances
- Give the postgresql pods a higher priority class

## Configuration

- Define the resources (requests and limits in the cluster)
- Try not to enable superuser access (spec.enableSuperuserAccess). You can create additional roles with the needed permissions.
- Always configure backup using the backup plugin
- Review backups status

## Karpenter and cluster autoescaler

Until 1.26 release, cloudnative-pg only detects a node is being drained if detects via the node.kubernetes.io/unschedulable taint

Since 1.26 release, cloudnative-pg detects a node is being drained with these taints:

- node.kubernetes.io/unschedulable
- ToBeDeletedByClusterAutoscaler
- karpenter.sh/disrupted
- karpenter.sh/disruption

When karpenter and cluster autoscaler taints the node, the controller knows the node will be delete and it can initiate a failover
