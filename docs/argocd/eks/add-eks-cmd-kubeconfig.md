# Add eks cluster with cmdline and a kubeconfig

## New kubeconfig

Get the kubeconfig of the new eks cluster

```shell
aws configure list-profiles # see my profiles
export AWS_PROFILE=myprofile
aws eks list-clusters  # check the clusters
aws eks update-kubeconfig --kubeconfig /path/to/newcluster/kubeconfig.yaml --name remotecluster
```

## Get the context

```shell
export KUBECONFIG=/path/to/newcluster/kubeconfig.yaml
kubectl config get-contexts
```

## Add the cluster to argocd

### Login to the argocd management cluster

argocd login --grpc-web FQDN_OF_THE_ARGOCD_MANAGEMENT_CLUSTER

### Add the cluster

> The access to the cluster api must be permitted

```shell
argocd cluster add CONTEXT  \
--name DESIRED-CLUSTER-NAME \
--kubeconfig /path/to/newcluster/kubeconfig.yaml  \
--cluster-endpoint kubeconfig
```

## Final steps

### First app

Deploy an application in the cluster to force to check if it is ok create, for example ingress-nginx

### Rename the cluster

```shell
kubectl get secret
kubectl get secret MYNEWCLUSTERSECRETWITHLONGNAME -o yaml > /patch/to/folder/with/clusters/MYNEWCLUSTER.yaml
```

- Clean the secret and change the name
- Add it to the kustomization file.
- Commit, push and sync
- Check if the cluster is ok
- Delete the original long secret

```shell
kubectl delete secret MYNEWCLUSTERSECRETWITHLONGNAME
```
