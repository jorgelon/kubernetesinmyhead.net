# NAT Gateway Deployment Patterns

AWS offers three NAT Gateway deployment patterns. Choosing the right one impacts availability,
operational complexity, and cost.

## Patterns Overview

### Single NAT Gateway

One NAT Gateway in a single AZ, shared by all private subnets across all AZs.

**AWS explicitly warns:**

> "If you have resources in multiple Availability Zones and they share one NAT gateway, and if the
> NAT gateway's Availability Zone is down, resources in the other Availability Zones lose internet
> access."

Use only for dev/test where cost matters more than availability.

---

### One NAT Gateway per AZ

The traditional best practice: one NAT Gateway per AZ, each private subnet routes to its local NAT.

Provides true fault isolation but requires:

- N gateways, N route tables, N Elastic IPs
- Manual cleanup when AZs are decommissioned
- Repeated work every time workloads expand to a new AZ

AWS pricing docs confirm the cost rationale:

> "If your AWS resources send or receive a significant volume of traffic across Availability Zones,
> ensure that the resources are in the same Availability Zone as the NAT gateway. Alternatively,
> create a NAT gateway in each Availability Zone with resources."

---

### Regional NAT Gateway (November 2025)

A single NAT Gateway that automatically expands and contracts across AZs based on workload presence.

**AWS official recommendation:**

> "Consider using Regional NAT Gateways for all use cases except those that require private
> connectivity. Regional NAT Gateways do not offer private connectivity and we recommend using your
> NAT Gateways in zonal availability mode for private NAT use cases."

Key benefits over zonal:

| Feature | Zonal | Regional |
|---|---|---|
| Public subnet required | Yes | No |
| Route table management | One per AZ | Single entry for all AZs |
| HA | Manual (create per AZ) | Automatic |
| IP addresses per AZ | Up to 8 | Up to 32 |
| Private NAT support | Yes | No |

Two sub-modes:

- **Automatic** (recommended): AWS manages IP addresses and AZ expansion
- **Manual**: you manage IP addresses and control per-AZ expansion

**Caveat:** up to 60 minutes to expand to a new AZ after a workload starts there. During that
window, traffic is proxied cross-zone by the gateway in an existing AZ.

## Decision Matrix

| Scenario | Pattern |
|---|---|
| Production, public internet egress, multi-AZ | Regional |
| Private NAT / private connectivity | Per-AZ zonal |
| High cross-AZ traffic volume (cost-sensitive) | Per-AZ zonal |
| Dev / test | Single |

## Private NAT

A NAT Gateway in **private connectivity mode** has no Elastic IP and does not route to the
internet. It translates source IPs to enable communication between **private networks with
overlapping CIDRs**.

Typical use case: VPC-A (`10.0.0.0/16`) needs to reach VPC-B (`10.0.0.0/16`). Normal VPC
peering or Transit Gateway routing fails due to overlapping ranges. A private NAT Gateway
translates the source IP before forwarding, resolving the conflict.

Regional NAT Gateways do not support this mode. Use per-AZ zonal NAT Gateways for private
connectivity.

## Cost Notes

Hourly billing for Regional NAT Gateway is **per active AZ** — same rate as per-AZ zonal
(`~$0.045/hr` per AZ in us-east-1). Regional mode is **not cheaper**; it is operationally simpler.

With a single NAT Gateway, cross-AZ data transfer adds `$0.01/GB per direction` (`$0.02/GB`
round-trip). At roughly **4.8 TB/month** distributed across 3 AZs, per-AZ zonal becomes cheaper
than a single gateway.

Use [Gateway VPC Endpoints](https://docs.aws.amazon.com/vpc/latest/privatelink/gateway-endpoints.html)
for S3 and DynamoDB to bypass NAT Gateway data processing charges entirely.

## References

- [Regional NAT gateways - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateways-regional.html)
- [NAT gateway basics - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-basics.html)
- [Pricing for NAT gateways - AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-pricing.html)
