# Eks Pod identity agent

Eks pod identity is a feature in Amazon EKS that simplifies the process to give permissions to a kubernetes service accounts inside an eks cluster.

## Install the agent addon

Install the Amazon EKS Pod Identity Agent to EKS

## Policy

Create a policy with the desired permissions

## Role

Create a role with that policy and this trust relationship

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

## Add the association in EKS

In our eks cluster - Access tab, create a new Pod Identity association

- choose the created iam role
- choose the namespace
- choose an existing service account inside that namespace

And that's it!!

> The service account or the application usually don't need additional settings (no arn, no annotation,..). But check the documentation or forums in every case.

## Links

- EKS Pod Identities  
<https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html>

- Github  
<https://github.com/aws/eks-pod-identity-agent>
