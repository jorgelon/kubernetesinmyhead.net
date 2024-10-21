# Add a kubernetes cluster to argocd via cli

This has been tested with a normal kubeconfig (not a eks cluster or similar)

## Requirements

In order to add or modify an argocd cluster with the argocd cli we need this in the same terminal:

- The argocd cli with the version of the argocd server. Please see <https://argo-cd.readthedocs.io/en/stable/cli_installation/>

```shell
release=v2.11.11
curl -fSsL https://github.com/argoproj/argo-cd/releases/download/${release}/argocd-linux-amd64 -o argocd
chmod 750 argocd
./argocd version --client
```
<!-- - The kubeconfig file loaded in memory of the argocd instance where we want to add a new cluster -->

- Access to the clean (with no contexts) kubeconfig file related with the kubernetes cluster we want to add to argocd

For example, in a kubeadm deployed kubernetes cluster we can get the kubeconfig from a master server

```shell
master_server=MY_MASTER_SERVER
ssh core@$master_server sudo cat /etc/kubernetes/admin.conf >$master_server.kubeconfig
```

## Steps

```shell
./argocd login MY-ARGOCD-CLUSTER  # Log in our argocd server
./argocd cluster list # list the name of the clusters we have
KUBECONFIG=PATH_TO_KUBECONFIG kubectl config get-contexts # get the context of the new kubernetes cluster
```

Add a new cluster

```shell
./argocd cluster add MYCONTEXT  \
--kubeconfig PATH_TO_NEW_CLUSTER_KUBECONFIG \
--name NEW_CLUSTER_NAME \
--project MY_PROJECT \
--cluster-endpoint kubeconfig \
--grpc-web
```

Overriding an existing cluster

```shell
./argocd cluster add MYCONTEXT  \
--kubeconfig PATH_TO_NEW_CLUSTER_KUBECONFIG \
--name NOMBRE_DEL_CLUSTER \
--project MY_PROJECT \
--cluster-endpoint kubeconfig \
--grpc-web \
--upsert
```

## Notes

- This fixed the following error:
"the server has asked for the client to provide credentials"

- I haven't found a way to make "argocd admin cluster generate-spec" work
