# IRSA

## OIDC

Create an IAM OIDC provider for your cluster
  
<https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html>

## Create the Policy

Create a policy with the desired permissions to the kubernetes application

## Create the role

Create a role with that policy and this trust relationship

You can use the folling script

[Generate Trust Relationship Script](./irsa.sh)

## Annotation

Add the following annotation to the service account that needs the permissions

```txt
eks.amazonaws.com/role-arn: THE-CREATED-ROLE-ARN
```

## Links

- Create and associate IAM Role

<https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html>
