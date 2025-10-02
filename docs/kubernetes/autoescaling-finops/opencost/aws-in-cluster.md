# AWS Regular OpenCost (in-cluster costs)

Opencost gets the following information

- Kubernetes Resource Usage Metrics (via Prometheus)

OpenCost queries Prometheus for historical usage data so you need metrics from kubelet, node-exporter or kube-state-metrics)

- AWS Instance Information (from Kubernetes Node Metadata)

It also get aws instance information like instance type, AWS region,
Availability zone, Provider ID

- AWS Pricing Data (from Public AWS Pricing API)

It gets EC2 on-demand instance pricing (per instance type, per region), CPU pricing (per vCPU-hour), Memory pricing (per GB-hour), EBS storage pricing, Network egress pricing (inter-AZ and internet)

It automatically detects AWS as the cloud provider and fetches pricing from AWS public pricing endpoint:

<https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/${node_region}/index.json>

## Limitations Without CUR

- Uses list prices - not your actual negotiated AWS rates
- No reserved instance discounts - cannot track RI or Savings Plans
- Spot pricing is estimated - not actual billed spot prices
- No other AWS services - only EC2/EBS visible (no S3, RDS, etc.)
- No reconciliation - costs are estimates until CUR data is integrated
