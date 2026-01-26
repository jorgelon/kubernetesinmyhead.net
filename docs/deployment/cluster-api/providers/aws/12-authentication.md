# Authentication

## Cloudformation Stack user

The user that creates the Cloudformation Stack must have be an administrative user in an AWS account. It is authenticated via the following environment variables

```txt
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN (MFA)
```

Then it will do a **clusterawsadm bootstrap iam create-cloudformation-stack --config myconfig.yaml**

> This command also updates the current Cloudformation Stack settings

More info here

<https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>

## Capa Controller credentials

We need to give credentials to the CAPA controller in order to manage aws resources. It can be a good practice to create an specific user/role different from the user that created the Cloudformation Stack.

We can achieve that via spec.bootstrapUser in our AWSIAMConfiguration file

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  bootstrapUser:
    enable: true
    userName: capa-manager-user # Defaults to “bootstrapper.cluster-api-provider-aws.sigs.k8s.io”
    groupName:  capa-manager-group # Defaults to “bootstrapper.cluster-api-provider-aws.sigs.k8s.io”
```

> We can also provide a prefix and suffix via spec.namePrefix and spec.nameSuffix. This affects to roles, users and policies.

We must translate the credentials for this user/role to the CAPA controller. For example:

- Create an access key for the user and load in an aws profile
- Load the aws profile and create a secret in the kubernetes cluster where the controller will be deployed.

## Separate EKS roles

When deploying EKS clusters, by default they share the same IAM roles. If we want different roles per cluster, we must permit the EKS controller to create IAM roles per EKS cluster

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  eks:
    iamRoleCreation: true
```

... and enable the EKSEnableIAM feature in the provider, that enables the automatic creation of unique IAM roles for each individual EKS cluster.

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
spec:
  manager:
    featureGates:
      EKSEnableIAM: true
