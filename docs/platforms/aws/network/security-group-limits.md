# Security Group Rules Limits

AWS enforces quotas on security group rules at multiple dimensions. Understanding how
they interact prevents hitting unexpected limits.

## Core Quotas

| Name                                  | Default | Adjustable     |
|---------------------------------------|---------|----------------|
| Inbound rules per security group      | 60      | Yes            |
| Outbound rules per security group     | 60      | Yes            |
| Security groups per network interface | 5       | Yes (up to 16) |
| VPC security groups per Region        | 2,500   | Yes            |

## How the 60-rule limit is counted

The limit is enforced **independently** across four dimensions:

- 60 inbound IPv4 rules
- 60 inbound IPv6 rules
- 60 outbound IPv4 rules
- 60 outbound IPv6 rules

A single security group can therefore hold up to **240 rules** across all dimensions.

## Hard constraint: rules × security groups per ENI ≤ 1,000

These two quotas are linked:

> "This quota multiplied by the quota for security groups per network interface cannot
> exceed 1,000."

With defaults: `60 rules × 5 SGs = 300` — within the cap. If you increase one quota,
the other gets constrained:

| Rules per SG | Max SGs per ENI |
|--------------|-----------------|
| 60 (default) | up to 16        |
| 100          | 10              |
| 200          | 5               |
| 500          | 2               |

Request increases via Service Quotas console → Elastic Load Balancing, or via CLI:

```bash
aws ec2 describe-account-attributes --attribute-names max-security-groups-per-interface
```

## How prefix list references count

The type of source/destination determines how each rule contributes to the quota:

| Source/destination type      | Counts as                       |
|------------------------------|---------------------------------|
| CIDR block                   | 1 rule                          |
| Another security group       | 1 rule (regardless of its size) |
| Customer-managed prefix list | **max size** of the prefix list |
| AWS-managed prefix list      | **weight** defined by AWS       |

### Customer-managed prefix lists

A rule referencing a prefix list with a max size of 20 counts as **20 rules**, even if
only 5 entries are currently in it. When you resize the prefix list, the security group
rule consumption **updates automatically** — no need to re-add the rule.

This means:

- Resizing up immediately consumes more of your quota. If a referencing security group
  would exceed its rules quota after the resize, **the operation is rejected** and the
  previous max size is restored.
- Resizing down immediately frees slots, but you cannot reduce the max below the number
  of **current entries** in the list.
- Avoid setting a larger max size than needed.

### AWS-managed prefix lists

AWS-managed prefix lists (e.g. for S3, CloudFront, DynamoDB) have a fixed **weight**
that counts against the quota instead of a max size. The weight is listed in the
[AWS-managed prefix lists documentation](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-aws-managed-prefix-lists.html#available-aws-managed-prefix-lists).

## References

- [Amazon VPC quotas - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html)
- [Security group rules - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/security-group-rules.html)
- [Managed prefix lists - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html)
