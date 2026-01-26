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

## Coredns enabled

With empty addons coredns is deployed via deployment. Default eks behaviour. Is it related with bootstrapSelfManagedAddons?

## MachinePools and AWSManagedMachinePool maturity

Is it mature?

## Auth with empty clusters

It is neccesary to configure authentication in the controller when no kubernetes clusters are deployed yet
