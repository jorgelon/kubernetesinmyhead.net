# Auto Mode

## EKS Addons Deployed by Auto Mode

When you enable EKS Auto Mode, AWS automatically deploys and manages the following essential cluster capabilities:

- **Pod networking** - Amazon VPC CNI plugin for Kubernetes networking
- **Service networking** - kube-proxy for Kubernetes service discovery
- **Cluster DNS** - CoreDNS for internal cluster DNS resolution
- **Autoscaling** - Karpenter for compute autoscaling
- **Block storage** - Amazon EBS CSI Driver for persistent volume support
- **Load balancer controller** - AWS Load Balancer Controller for ALB/NLB integration
- **Pod Identity agent** - EKS Pod Identity Agent for IAM role management
- **Node monitoring agent** - CloudWatch agent for node metrics
