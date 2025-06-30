# Add a cluster

We want to update the credentials for a kubernetes cluster added to argocd.

> This has been tested with a kubeadm cluster (not a eks cluster or similar)

We will have

- The kubeconfig file of the argocd main instance that will receive the new cluster
- The kubeconfig file of the argocd instance we want to add to the main instance

## Login to the argocd main instance

For that we need:

```shell
argocd login --grpc-web MY-ARGOCD-SERVER # Log in our argocd server
argocd login --sso --grpc-web MY-ARGOCD-SERVER # or via sso
```

## Context

Get the context for the cluster we want to add

```shell
KUBECONFIG=PATH_TO_KUBECONFIG kubectl config get-contexts
```

## Add a temporary cluster

Then add the cluster with a temporary name

```shell
argocd cluster add MYCONTEXT --kubeconfig PATH_TO_KUBECONFIG --name CLUSTER_NAME --project MY_PROJECT --cluster-endpoint kubeconfig --grpc-web 
```

This creates

- a ServiceAccount "argocd-manager"
- a ClusterRole "argocd-manager-role"
- a ClusterRoleBinding "argocd-manager-role-binding"
- a Created bearer token secret for ServiceAccount "argocd-manager"

## Notes

The temporary name permits to explore the new secret created in the argocd namespace and get the config key that stores the cluster configuration

Copying that config to an existing cluster fixes the following error:

```txt
the server has asked for the client to provide credentials
```
