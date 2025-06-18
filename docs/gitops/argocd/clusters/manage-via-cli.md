# Manage via cli

## Add or update a cluster

We want to update the credentials for a kubernetes cluster added to argocd.

This also fixes the following error:

```txt
the server has asked for the client to provide credentials
```

For that we need:

- A kubeconfig with the credentials for the cluster we want to update the credentials

> This has been tested with a kubeadm cluster (not a eks cluster or similar)

```shell
argocd login --grpc-web MY-ARGOCD-SERVER # Log in our argocd server
argocd login --sso --grpc-web MY-ARGOCD-SERVER # or via sso
```

Get the context from the kubeconfig

```shell
KUBECONFIG=PATH_TO_KUBECONFIG kubectl config get-contexts
```

Then add the cluster with a temporary name

```shell
argocd cluster add MYCONTEXT --kubeconfig PATH_TO_KUBECONFIG --name CLUSTER_NAME --project MY_PROJECT --cluster-endpoint kubeconfig --grpc-web --upsert
```

> --upsert overwrites the existing cluster. If you choose a different name you will add the same cluster with another name, but this permits to explore the config key in the kubernetes secret that stores the cluster configuration

This creates

- a ServiceAccount "argocd-manager"
- a ClusterRole "argocd-manager-role"
- a ClusterRoleBinding "argocd-manager-role-binding"
- a Created bearer token secret for ServiceAccount "argocd-manager"
