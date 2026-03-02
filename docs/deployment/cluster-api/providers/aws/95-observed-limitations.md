# Observed limitations

## EKS auto mode

EKS auto mode is not supported yet

- <https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/5278>
- <https://github.com/kubernetes-sigs/cluster-api-provider-aws/pull/5642>

## VPC resource is missing in AWS

```txt
.spec.vpc.id is set but VPC resource is missing in AWS; failed to describe VPC resources. (might be in creation process): failed to query ec2 for VPCs: operation error EC2: DescribeVpcs, exceeded maximum number of attempts, 3, Probable clock skew error
```

Permissions?

See <https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/4191>

## Nat gateways

It is not possible to configure only 1 Nat gateway en a 3 zone eks cluster

<https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/1323>
<https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/1484>

### Regional NAT gateway not supported

AWS announced regional NAT gateways in November 2025. A regional NAT gateway spans
multiple AZs automatically without requiring a public subnet per AZ. CAPA does not
support this mode yet. There is an open feature request:

<https://github.com/kubernetes-sigs/cluster-api-provider-aws/issues/5790>

## MachinePools and AWSManagedMachinePool maturity

Is it mature?

## Auth with empty clusters

It is neccesary to configure authentication in the controller when no kubernetes clusters are
deployed yet. See [Management Cluster](10-management-cluster.md) for details on controller
credential options.
