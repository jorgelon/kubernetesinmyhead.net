# Service annotations

This annotations permits to expose services via NLB adding them:

- to a kubernetes service
- to a gateway settings (gateway api)

I will describe some of the more important annotations

## service.beta.kubernetes.io/aws-load-balancer-nlb-target-type

This annotation sets the target type for the NLB. It accepts two values: `instance` or `ip`.

### instance mode (default)

Routes traffic to EC2 instances through their NodePort. Works with any CNI plugin but adds an extra network hop through kube-proxy.

### ip mode

Routes traffic directly to Pod IPs. Requires AWS VPC CNI (or equivalent) to assign secondary IP addresses to EC2 instance ENIs. Lower latency and better performance than instance mode, but more complex networking requirements and cannot be changed after NLB creation.

## CNI Plugin Compatibility with IP Mode

- **AWS VPC CNI**: ✅ Full support
- **Cilium**: ⚠️ ENI mode has known compatibility issues with AWS Load Balancer Controller (GitHub Issues #19250, #19981). CNI chaining mode works normally.
- **Calico**: ⚠️ Policy-only mode works when used alongside AWS VPC CNI. Full CNI mode does not support IP targets.
