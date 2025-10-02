# AWS Billing

Cost and Usage Report (CUR) or Cost Explorer API

## Summary

Amazon Athena is a serverless, interactive query service that allows you to analyze data directly in Amazon S3 using standard SQL. We will do this:

- Export the billing data to a s3 bucket
- Configure Athena to analyze that information
- Configure Opencost to use that Athena settings

## Buckets

Create 2 s3 buckets

- One for the billing data
- Another required for Athena results

## Create data export

Using the AWS Console, go to Billing and Cost Management > Cost & Usage Analysis > Data exports and create an export

Choose the export name and the s3 bucket and prefix. Also:

```yaml
Type: Standard data export
Name: Choose one, for example opencost-myekscluster
Data table content settings: CUR 2.0
Additional export content: Check "Include resource IDs" # https://github.com/opencost/opencost/issues/3076
Time granularity: Hourly (recommended)
Compression type and file format: Parquet (optimized for Athena)
S3 bucket: Choose the s3bucket created for the billing data
S3 path prefix: Choose a prefix
```

> First export can take 24-48 hours to appear in S3. Wait for initial data generation exploring the s3 bucket some hours later.
>
## Configure Athena

Using the AWS Console, go to AWS Athena

### Workgroup

Create an Athena workgroup for opencost:

- Query result configuration: customer-managed
- Location of query result: associate the created bucket for athena queries

### Create database and table

Under athena query editor, select the workgroup opencost and

```sql
CREATE DATABASE IF NOT EXISTS opencost_cur;
```

Then choose the database from the dropdown menu and

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS opencost_cur.cur_data (
  bill_bill_type STRING,
  bill_billing_entity STRING,
  bill_billing_period_end_date TIMESTAMP,
  bill_billing_period_start_date TIMESTAMP,
  bill_invoice_id STRING,
  bill_invoicing_entity STRING,
  bill_payer_account_id STRING,
  bill_payer_account_name STRING,
  cost_category MAP<STRING, STRING>,
  discount MAP<STRING, STRING>,
  discount_bundled_discount DOUBLE,
  discount_total_discount DOUBLE,
  identity_line_item_id STRING,
  identity_time_interval STRING,
  line_item_availability_zone STRING,
  line_item_blended_cost DOUBLE,
  line_item_blended_rate STRING,
  line_item_currency_code STRING,
  line_item_legal_entity STRING,
  line_item_line_item_description STRING,
  line_item_line_item_type STRING,
  line_item_net_unblended_cost DOUBLE,
  line_item_net_unblended_rate STRING,
  line_item_normalization_factor DOUBLE,
  line_item_normalized_usage_amount DOUBLE,
  line_item_operation STRING,
  line_item_product_code STRING,
  line_item_tax_type STRING,
  line_item_unblended_cost DOUBLE,
  line_item_unblended_rate STRING,
  line_item_usage_account_id STRING,
  line_item_usage_account_name STRING,
  line_item_usage_amount DOUBLE,
  line_item_usage_end_date TIMESTAMP,
  line_item_usage_start_date TIMESTAMP,
  line_item_usage_type STRING,
  pricing_currency STRING,
  pricing_lease_contract_length STRING,
  pricing_offering_class STRING,
  pricing_public_on_demand_cost DOUBLE,
  pricing_public_on_demand_rate STRING,
  pricing_purchase_option STRING,
  pricing_rate_code STRING,
  pricing_rate_id STRING,
  pricing_term STRING,
  pricing_unit STRING,
  product MAP<STRING, STRING>,
  resource_tags MAP<STRING, STRING>
)
PARTITIONED BY (
  billing_period STRING
)
STORED AS PARQUET
LOCATION 's3://MYBUCKET/path-to-data/'
TBLPROPERTIES ('parquet.compression'='SNAPPY');
```

### Add Partition

```sql
ALTER TABLE opencost_cur.cur_data ADD IF NOT EXISTS
PARTITION (billing_period='2025-09')
LOCATION 's3://BUCKET/path-to-data/BILLING_PERIOD=2025-09/';
```

Or repair all partitions:

```sql
MSCK REPAIR TABLE opencost_cur.cur_data;
```

### Test Query

```sql
SELECT
  line_item_usage_start_date,
  line_item_product_code,
  SUM(line_item_unblended_cost) as cost
FROM opencost_cur.cur_data
WHERE billing_period = '2025-09'
GROUP BY line_item_usage_start_date, line_item_product_code
LIMIT 10;
```

## Opencost

### Opencost Iam permissions

OpenCost supports four AWS authorizer types:

  1. AccessKey - Direct AWS access key and secret authentication
  2. ServiceAccount - Kubernetes service account with pod annotations
  3. AssumeRole - IAM role assumption using another authorizer
  4. WebIdentity - Web identity token authentication (supports Google as identity provider)

The Service Account authorizer leverages Kubernetes service account annotations and works with AWS pod identity mechanisms like:

- EKS Pod Identity
- IAM Roles for Service Accounts (IRSA)

A very open policy can be [this](policy.json)

## Opencost settings

- For Pod Identity Access
- Creating a secret called cloud-costs using externalsecrets operator. The target of the external-secret can be [this](eso-target.yaml)

## Opencost deployment

Configure opencost using helm chart for aws billing, choosing our secret

```yaml
opencost:
  cloudIntegrationSecret: "cloud-costs"
  cloudCost:
    enabled: true
  exporter: # this fixed a bug mounting the secret?
    extraVolumeMounts:
      - mountPath: "/var/configs"
        name: cloud-integration
```

## Links

- Installing on Amazon Web Services (AWS)

<https://opencost.io/docs/configuration/aws/>

- Creating reports

<https://docs.aws.amazon.com/cur/latest/userguide/cur-create.html>

- IAM

<https://github.com/opencost/opencost/issues/3056>
<https://github.com/opencost/opencost/issues/1217>
<https://github.com/opencost/opencost/issues/3204>
<https://github.com/opencost/opencost/issues/2869>

<https://medium.com/@prassonmishra330/cloud-cost-integration-aws-with-opencost-8b9557448e3a>
