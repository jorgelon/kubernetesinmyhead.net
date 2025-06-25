# Upgrade

### Read the kubernetes changes

Check the changes between releases

- Releases

<https://kubernetes.io/releases/>

- Blog

<https://kubernetes.io/blog/>

## Read the documentation about upgrading process

- Upgrade A Cluster

<https://kubernetes.io/docs/tasks/administer-cluster/cluster-upgrade/>

- Upgrading kubeadm clusters

<https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/>

- Upgrading Linux nodes

<https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/upgrading-linux-nodes/>

### Compatibility

Check the compatibility between all your applications and the new kubernetes release. For example:

- CSI driver (cilium,...)
- CNI driver (vmware, nfs,..)

### Check deprecated apis

Kubernetes apis can change between release

<https://kubernetes.io/docs/reference/using-api/deprecation-guide/>

Tools to check

- Silver Surfer

<https://github.com/devtron-labs/silver-surfer>>

- Pluto

<https://github.com/FairwindsOps/pluto>

- Kubepug

<https://github.com/kubepug/kubepug>
