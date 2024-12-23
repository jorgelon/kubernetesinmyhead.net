# IRSA

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
