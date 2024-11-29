# CNPG in production

## Deployment

- Use gitops tools (argocd, flux,...) to control the deployment
- Use gitops tools like external-secrets operator to control the credentials
- You can enable the spec.monitoring.enablePodMonitor setting and setup a monitoring and alerting system

## Configuration

- Always setup a backup section in our clusters and review the status of the backups
- Try not to enable spec.enableSuperuserAccess
- Configure the primaryUpdateStrategy
- Define the resources (requests and limits in the cluster)
- Give the postgresql pods a higher priority class
- Leave spec.enablePDB enabled (default)
- Use odd replicas (3, 5, ...)
- Configure the affinity section to distribute the instances in nodes
- Use selectors and taints/tolerations to have the cluster pods in a nodes with an appropiate performance
- You can also dedicate nodes to the postgresql instances
