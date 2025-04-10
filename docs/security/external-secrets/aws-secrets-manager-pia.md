# Aws Secrets Manager with PIA

## Role and policies

Create a role called, for example external-secrets with this trust policy (trust relationship)

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

And with this permission policy called, for example AllowPullSecrets

```json
{
    "Statement": [
        {
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Effect": "Allow",
            "Resource": [
                "*"
            ]
        }
    ],
    "Version": "2012-10-17"
}
```

> The policy can be more precise for your secret

## Aws Secrets Manager

Go to Aws Secrets Manager and Store a new secret with "secret type" "Other type of secret" and put some key/value

## Deploy external secrets

Deploy the external dns helm chart

## Configure the eks cluster

- Under addons, deploy the pod identity agent plugin if not using Eks Auto Mode

- Under access, create a pod identity association between the external-secrets role and the external-secrets service account

## Create a secret store

In order to check if it is working, create a secret store

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: mystore
spec:
  provider:
    aws:
      service: SecretsManager
      region: YOURREGION
```

... and see the logs in the secret manager pod

> Probably a restart of the external-secrets deployment is needed

```shell
kubectl rollout restart deployment external-secrets -n external-secrets
```

## Links

- AWS Secrets Manager

<https://external-secrets.io/latest/provider/aws-secrets-manager/>
