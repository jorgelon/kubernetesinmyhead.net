# Route53 and Pod identity agent

## Role and policies

Create a role called, for example external-dns with this trust policy (trust relationship)

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEksAuthToAssumeRoleForPodIdentity",
            "Effect": "Allow",
            "Principal": {
                "Service": "pods.eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
}
```

And with this permission policy called, for example AllowExternalDNSUpdates

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResources"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

> The policy can be more precise for your hosted zone

## Route 53 zone

Create a hosted zone in route 53 for your desired (sub)domain

## Deploy external dns

Deploy the external dns helm chart with this values.yaml file

```yaml
provider:
  name: aws
domainFilters:
  - yourhostedzone
txtOwnerId: the txtOwnerId of yourhostedzone
extraArgs: ["--aws-zone-type=public"]   # if it is a public zone
```

> If you use a very old release, pod identity agent can fail

## Configure the eks cluster

- Under addons, deploy the pod identity agent plugin if not using Eks Auto Mode

- Under access, create a pod identity association between the external-dns role and the external-dns service account

## Check if it works

Restart the external-dns deployment and see the logs of the external-dns pod. You must find something like this:

```yaml
"Applying provider record filter for domains: [yourhostedzone related info ]"
"All records are already up to date"
```
