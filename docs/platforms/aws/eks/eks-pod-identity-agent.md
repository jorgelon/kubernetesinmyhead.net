# Eks Pod identity agent

Eks pod identity is a feature in Amazon EKS that simplifies the process to give permissions to a kubernetes service accounts inside an eks cluster.

## Prepare the system

<https://docs.aws.amazon.com/eks/latest/userguide/pod-id-agent-setup.html>

### Policy to the nodes

Ensure the AmazonEKSWorkerNodePolicy policy is added to the node role

### Install the agent addon

Install the Amazon EKS Pod Identity Agent addon to EKS

### Prepare IAM

## Create the Policy

Create a policy with the desired permissions to the kubernetes application

## Create the role Role

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

### Add the association in EKS

<https://docs.aws.amazon.com/eks/latest/userguide/pod-id-association.html>

In our eks cluster - Access tab, create a new Pod Identity association

- choose the created iam role
- choose the namespace
- choose an existing service account inside that namespace

And that's it!!

> The service account or the application usually don't need additional settings (no arn, no annotation,..). But check the documentation or forums for every application in order to use Pod Identity Agent

## Links

- EKS Pod Identities  
<https://docs.aws.amazon.com/eks/latest/userguide/pod-identities.html>

- Github  
<https://github.com/aws/eks-pod-identity-agent>
