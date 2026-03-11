# Update

Steps to update an EKS cluster to a new Kubernetes version.

> **Important**: You can only upgrade **one minor version at a time** (e.g., 1.29 → 1.30).
> Downgrades are not supported. Once the upgrade starts, it cannot be paused or stopped.

## Step 0: Read Changelogs

- Read the kubernetes changelog in <https://kubernetes.io/releases/>
- Read the eks changelog in <https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-standard.html>
- Read the official eks update document in <https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html>

## Step 1: Pre-upgrade checks

### Cluster health

- Verify there are no current problems in the cluster
- Enable control plane logging to capture issues during upgrade: <https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html>
- Optionally, back up the cluster before upgrading: <https://docs.aws.amazon.com/eks/latest/userguide/integration-backup.html>

### Node version skew

Nodes must be on the same minor version as the control plane before upgrading the control plane.
Starting from Kubernetes 1.28, kubelet may be up to **3 minor versions** older than the kube-apiserver (2 minor versions for ≤1.27).

```bash
kubectl version
kubectl get nodes
```

### EKS upgrade insights

Check Amazon EKS upgrade insights in the console (Observability → Upgrade insights tab) or with the CLI:

```bash
aws eks list-insights --cluster-name <cluster-name> --region <region>
```

Insights are refreshed every 24 hours, or you can refresh them manually. Fix all findings before proceeding.
Note: it can take up to 30 days for insights to clear after fixing deprecated API usage (rolling 30-day window).

### Kubernetes API compatibility

Check for deprecated or removed APIs using tools like:

- [pluto](https://github.com/FairwindsOps/pluto)
- [kubectl convert plugin](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-convert-plugin)
- Review: <https://kubernetes.io/docs/reference/using-api/deprecation-guide/>

### Infrastructure requirements

Amazon EKS requires up to **5 available IP addresses** from the subnets specified at cluster creation:

```bash
CLUSTER=<cluster-name>
aws ec2 describe-subnets --subnet-ids \
  $(aws eks describe-cluster --name ${CLUSTER} \
  --query 'cluster.resourcesVpcConfig.subnetIds' \
  --output text) \
  --query 'Subnets[*].[SubnetId,AvailabilityZone,AvailableIpAddressCount]' \
  --output table
```

Also verify the cluster IAM role is present and has the correct permissions (including KMS key access if secret encryption is enabled).

### Add-ons compatibility

The installed add-ons must be compatible with the next release. Check cluster insights for this.
Update add-ons to a version compatible with **both** the current and target Kubernetes versions before upgrading.

EKS add-ons are **not** automatically upgraded during a control plane upgrade. They can only be upgraded one minor version at a time.

Relevant add-on docs:

- VPC-CNI: <https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html>
- CoreDNS: <https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html>
- kube-proxy: <https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html>
- EBS CSI: <https://docs.aws.amazon.com/eks/latest/userguide/managing-ebs-csi.html>
- EFS CSI: <https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html>
- AWS Load Balancer Controller: <https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html>

### Application compatibility

Check critical workloads (ingress controllers, monitoring agents, storage drivers, autoscalers) for compatibility with the target Kubernetes version. Components using the Kubernetes API directly (often in `*-system` namespaces) are the most likely to be affected.

## Step 2: Upgrade the control plane

Trigger the control plane upgrade using one of:

**eksctl:**

```bash
eksctl upgrade cluster --name <cluster-name> --version <version-number> --approve
```

**AWS CLI:**

```bash
aws eks update-cluster-version --name <cluster-name> \
  --kubernetes-version <version-number> --region <region-code>

# Monitor the update status
aws eks describe-update --name <cluster-name> \
  --region <region-code> --update-id <update-id>
```

The update takes several minutes. AWS manages the rolling replacement of API server nodes; running workloads are not affected. If checks fail, EKS rolls back automatically.

## Step 3: Upgrade the worker nodes

After the control plane is upgraded, update all nodes to the same minor version.

**Managed node groups:**

```bash
aws eks update-nodegroup-version --cluster-name <cluster-name> \
  --nodegroup-name <nodegroup-name> --region <region-code>
```

**Self-managed nodes:** Replace nodes with new AMIs for the target version.
See: <https://docs.aws.amazon.com/eks/latest/userguide/update-workers.html>

**EKS Auto Mode:** No manual data plane upgrade needed — after the control plane upgrade, EKS Auto Mode incrementally updates managed nodes respecting PodDisruptionBudgets.

**Fargate:** New pods get the updated kubelet automatically. Redeploy existing Fargate pods to update them.

## Step 4: Post-upgrade tasks

- Update **Cluster Autoscaler** to match the new Kubernetes minor version:
  <https://github.com/kubernetes/autoscaler/releases>
- Update **NVIDIA device plugin** if the cluster has GPU nodes
- Update EKS add-ons (VPC CNI, CoreDNS, kube-proxy) to the recommended versions
- Update `kubectl` to within one minor version of the control plane

## EKS Auto Mode upgrades

With EKS Auto Mode the data plane upgrade is fully automated. After you initiate the control plane upgrade (same as any other cluster), Auto Mode handles the rest:

- As nodes expire, Auto Mode replaces them with new nodes running the target Kubernetes version.
- Pod disruption budgets are respected during node replacement.
- No manual node group update or rollout is needed.

### Components managed automatically

The following components are part of the Auto Mode service and **do not need manual updates**:

- Amazon VPC CNI
- CoreDNS
- kube-proxy
- AWS Load Balancer Controller
- Karpenter
- AWS EBS CSI driver

### Your responsibilities

You are still responsible for updating:

- Apps and workloads deployed to the cluster
- Self-managed add-ons and controllers
- Any Amazon EKS Add-ons installed manually

### Reference

- <https://docs.aws.amazon.com/eks/latest/userguide/auto-upgrade.html>

## Version lifecycle

- Standard support: **14 months** after release
- Extended support: **12 months** after end of standard support (additional cost)
- Clusters running past the 26-month lifecycle (standard + extended) are **auto-upgraded** by AWS

## Links

- Update existing cluster to new Kubernetes version: <https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html>
- Prepare for Kubernetes version upgrades with cluster insights: <https://docs.aws.amazon.com/eks/latest/userguide/cluster-insights.html>
- Best Practices for Cluster Upgrades: <https://docs.aws.amazon.com/eks/latest/best-practices/cluster-upgrades.html>
- Review release notes for Kubernetes versions on standard support: <https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-standard.html>
- Review release notes for Kubernetes versions on extended support: <https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-extended.html>
- Kubernetes changelogs: <https://github.com/kubernetes/kubernetes/tree/master/CHANGELOG>
- Kubernetes Deprecation Guide: <https://kubernetes.io/docs/reference/using-api/deprecation-guide/>
