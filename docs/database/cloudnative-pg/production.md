# CNPG in production

## Deployment

- Use gitops tools (argocd, flux,...) to control the deployment
- Use gitops tools like external-secrets operator to control the credentials

## Configuration

- Always setup a backup section in our clusters and review the status of the backups
- Try not to enable spec.enableSuperuserAccess
- Setup a primaryUpdateStrategy and primaryUpdateMethod (if unsupervised)
- Setup a monitoring and alerting system
- Define the resources (requests and limits in the cluster)
- Give the postgresql pods a higher priority class
- Leave spec.enablePDB enabled (default)
- USe odd replicas (3, 5, ...)
- Use antiaffinity to separate the instances in different nodes
- Use selectors and taints/tolerations to have the cluster pods in a nodes with an appropiate performance
- You can also dedicate nodes to the postgresql instances
