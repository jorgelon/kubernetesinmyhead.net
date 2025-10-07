# AWS Spot Instance Data Feed

It provides OpenCost accurate cost allocation and historical pricing data for spot instances.

> Spot instance prices fluctuate constantly. The Data Feed provides the actual prices paid at hourly granularity, which is more accurate than using current spot prices for historical costs.

To make it work we must:

- Configure an Spot Instance Data Feed
- Give opencost permissions to access to the spot feed bucket via IRSA or PIA

We can use the opencost cloud cost feature to get out-of-cluster costs

## Regional Availability

### Supported Regions

Spot Data Feed subscription is available in **all AWS regions except**:

- China (Beijing)
- China (Ningxia)
- AWS GovCloud (US)
- Regions that are disabled by default (opt-in regions)

### Opt-in Regions

Regions introduced after March 20, 2019 are disabled by default and require manual enablement:

- Africa (Cape Town) - af-south-1
- Asia Pacific (Hong Kong) - ap-east-1
- Europe (Milan) - eu-south-1
- Europe (Spain) - eu-south-2
- Middle East (Bahrain) - me-south-1
- Middle East (UAE) - me-central-1
- Asia Pacific (Hyderabad) - ap-south-2
- Asia Pacific (Jakarta) - ap-southeast-3
- Asia Pacific (Melbourne) - ap-southeast-4
- Canada (Central) - ca-west-1
- Europe (Zurich) - eu-central-2
- Israel (Tel Aviv) - il-central-1

**Important**: Even if an opt-in region is enabled, Spot Data Feed subscription may not be available. For example, eu-south-2 returns `UnsupportedOperation` error even when the region is enabled.

### Troubleshooting Regional Issues

If you encounter this error:

```
An error occurred (UnsupportedOperation) when calling the DescribeSpotDatafeedSubscription operation: The functionality you requested is not available in this region.
```

**Solution**: Use an alternative region where the service is fully supported, such as:

- eu-west-1 (Ireland)
- eu-central-1 (Frankfurt)
- us-east-1 (N. Virginia)

## Create Spot Data Feed Subscription

### AWS CLI Command

```bash
aws ec2 create-spot-datafeed-subscription \
    --dry-run \
    --bucket your-spot-datafeed-bucket \
    --prefix spot-datafeed/ \
    --region eu-south-2
```

```bash
aws ec2 create-spot-datafeed-subscription \
    --bucket your-spot-datafeed-bucket \
    --prefix spot-datafeed/ \
    --region us-east-1
```

### Parameters

- `--bucket`: S3 bucket name where spot pricing data will be stored
- `--prefix`: Optional prefix for the data files (recommended for organization)
- `--region`: AWS region where the subscription should be created

### Verify Subscription

```bash
aws ec2 describe-spot-datafeed-subscription
```

## Links

- Track your Spot Instance costs using the Spot Instance data feed

<https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-data-feeds.html>
