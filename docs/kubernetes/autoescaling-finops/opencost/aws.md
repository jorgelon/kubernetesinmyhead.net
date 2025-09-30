# AWS Integration

Opencost can access some information from prometheus and nodes metadata to show information but this have some limitations.

Adding acess to Cost and Usage Reports via cloud cost, it gets more relevevant information

## Regular OpenCost (in-cluster costs)

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

### Limitations Without CUR

Uses list prices - not your actual negotiated AWS rates
No reserved instance discounts - cannot track RI or Savings Plans
Spot pricing is estimated - not actual billed spot prices
No other AWS services - only EC2/EBS visible (no S3, RDS, etc.)
No reconciliation - costs are estimates until CUR data is integrated

## AWS Cloud Costs (out-of-cluster costs)

### AWS Spot Instance Data Feed

It provides OpenCost accurate cost allocation and historical pricing data for spot instances.

> Spot instance prices fluctuate constantly. The Data Feed provides the actual prices paid at hourly granularity, which is more accurate than using current spot prices for historical costs.

To make it work we must:

- Configure an Spot Instance Data Feed
- Give opencost permissions to access to the spot feed bucket via IRSA or PIA

We can use the opencost cloud cost feature to get out-of-cluster costs

### Cost and Usage Report (CUR) or Cost Explorer API

#### Create data export

Go to Billing and Cost Management > Cost & Usage Analysis > Data exports and create an export

Choose the export name and the s3 bucket and prefix. Also:

```txt
Standard data export
Data table content settings: CUR 2.0
Time granularity: Hourly (recommended)
Compression type and file format: Parquet (optimized for Athena)
```

> No dedicated Crossplane provider yet for the new BCM Data Exports service

#### Verification

- Wait for data

First export can take 24-48 hours to appear in S3. Wait for initial data Generation

- Athena

Amazon Athena is an interactive query service that lets you analyze data in S3 using standard SQL. AWS automatically creates a Glue Data Catalog database and table. Verify in Athena console or:

```shell
aws glue get-database --name <export-database-name>
aws glue get-table --database-name <export-database-name> --name <export-table-name>
```

```sql
SELECT * FROM <database>.<table> LIMIT 10;
```

#### Configure Opencost

- Create credentials with proper permissions
- Give that credentials to opencost to access this data

## Links

See more info here

- Cloud Service Provider Configuration

<https://opencost.io/docs/configuration/>

- Installing on Amazon Web Services (AWS)

<https://opencost.io/docs/configuration/aws/>

- Creating reports

<https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html>

- Track your Spot Instance costs using the Spot Instance data feed

<https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-data-feeds.html>
