# AWS Spot Instance Data Feed

It provides OpenCost accurate cost allocation and historical pricing data for spot instances.

> Spot instance prices fluctuate constantly. The Data Feed provides the actual prices paid at hourly granularity, which is more accurate than using current spot prices for historical costs.

To make it work we must:

- Configure an Spot Instance Data Feed
- Give opencost permissions to access to the spot feed bucket via IRSA or PIA

We can use the opencost cloud cost feature to get out-of-cluster costs
