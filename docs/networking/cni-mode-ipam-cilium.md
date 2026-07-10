# AWS VPC CNI Driver ipam

The AWS vpc cni driver has 2 working modes

## Secondary IP mode (standard)

This is the default mode. Is this mode every pod gets a real routable IP address from the AWS VPC subnet. No NAT is needed to talk with other aws resources.

Every EC2 instance type has two hard limits:

- Max ENIs it can attach
- Max IPs per ENI. One is reserved as primary ip for the ENI and it cannot be used by pods
- 2 additional slots are added for kube-proxy and aws-node pods

```txt
max_pods = (Number of ENIs × (IPV4 addresses per ENI − 1)) + 2
```

```txt
Example:
m5.large can have 3 ENIs and 10 IPs per ENI
```

## Prefix delegation mode

In this mode, AWS allocates whole /28 IP prefixes (16 IP addresses) instead of individual IPs to the network interfaces.

```txt
max_pods = (Number of ENIs × ((IPV4 addresses per ENI − 1) x16)) + 2
```

> We can enable prefix delegation with ENABLE_PREFIX_DELEGATION=true

## Example

|          | max ENIs | max ipv4 IPs per ENI | max_pods standard | max_pod prefix delegation |
|----------|----------|----------------------|-------------------|---------------------------|
| m5.large | 3        | 10                   | (3x(10-1))+2 = 29 | 3x9x16+2=434              |

This max pods is theorical.

## Warm pool

In both cases the cni driver permits to reserve Ip addresses and Elastic Network interfaces (warm pool)

This behaviour can be configured at CNI driver level with specifying some environment variables. There are 3 ways to do that

- **WARM_ENI_TARGET**

Specifying the number of spare ENIs via WARM_ENI_TARGET variable only

- **In standard mode: WARM_IP_TARGET + MINIMUM_IP_TARGET**

Configuring the the number of spare Ips via WARM_IP_TARGET and the number of pre-allocated IPs at node startup via MINIMUM_IP_TARGET

- **In prefix delegation mode: WARM_PREFIX_TARGET** variable only

The default value (1) gives 16 consecutive IPs as warm pool. If set, WARM_IP_TARGET and/or MINIMUM_IP_TARGET will take precedence over WARM_PREFIX_TARGET.

> In EKS auto mode these settings cannot be configured. The warm pool is managed internally by AWS

## Cilium in ENI mode

We can use Cilium in ENI mode instead of AWS VPC CNI driver. Also prefix delegation can be enabled.

The warm pool can be configured via this settings in the chart:

- ipam.nodeSpec.ipamPreAllocate configures the free IPs kept ready above current usage (similar to WARM_IP_TARGET)
- ipam.nodeSpec.ipamMinAllocate configures the IPs provisioned at node bootstrap (similar to MINIMUM_IP_TARGET)
- ipam.nodeSpec.ipamMaxAllocate configured a hard cap on IPs per node

> These settings also works in prefix delegation mode

## Links

- [Amazon VPC CNI](https://docs.aws.amazon.com/eks/latest/best-practices/vpc-cni.html)
- [Optimizing IP Address Utilization](https://docs.aws.amazon.com/eks/latest/best-practices/ip-opt.html)
- [Maximum IP addresses per network interface](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AvailableIpPerENI.html)
- [Prefix mode](https://docs.aws.amazon.com/eks/latest/best-practices/prefix-mode-linux.html)
- [Prefix delegation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-prefix-eni.html)
- [Amazon VPC CNI plugin increases pods per node limits](https://aws.amazon.com/blogs/containers/amazon-vpc-cni-increases-pods-per-node-limits/)
- [Cilium in eni mode](https://docs.cilium.io/en/stable/network/concepts/ipam/eni/)
