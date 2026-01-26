# Bootstrap

If we want to deploy the Kubernetes Cluster API Provider AWS (CAPA) using the cluster api operator we have the following steps

- Create all the necessary IAM resources needed for CAPA to manage AWS infrastructure
- Deploy the CAPA infraestructure provider

## Create the necessary IAM resources

We will use the **clusterawsadm** binary with a AWSIAMConfiguration configuration file. This will create a **CloudFormation stack** named cluster-api-provider-aws-sigs-k8s-io (by default) and includes:

- iam roles
- iam policies
- instance profiles

### Authentication

First of all we need to authenticate clusterawsadm with an administrative user using the following environment variables:

- AWS_REGION
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_SESSION_TOKEN (if using Multi-factor authentication)

### AWSIAMConfiguration file

Then we can configure clusterawsadm with a AWSIAMConfiguration file.

Some of the settings are:

- **Name and tags** for the Cloudformation stack
- The **region** to create it (if not priovided via environment variable or cli parameter)
- **Dedicated IAM user** (spec.bootstrapUser)

It creates a dedicated IAM user and group with proper permissions for bootstrapping and managing Cluster API AWS Provider resources. This avoid using personal AWS credentials and permit multitenancy scenarios.

> Later we can generate access keys for this user and use them when running **clusterawsadm bootstrap credentials encode-as-profile**

We can also add prefixes or suffixes to the roles, users and policies that will be created

```txt
Final IAM User Name: {namePrefix}{userName}{nameSuffix}
Final IAM Group Name: {namePrefix}{groupName}{nameSuffix}
```

> The default created user and group is **bootstrapper.cluster-api-provider-aws.sigs.k8s.io user**

- **EKS settings** (spec.eks)

Eks is enabled by default, but here we can enable separate roles per EKS cluster (iamRoleCreation), enable support for machinepool resources or fargate profiles so on

More settings and info

- Documentation <https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>
- AWSIAMConfiguration CRD <https://cluster-api-aws.sigs.k8s.io/crd/>

### Create CloudFormation stack

Now we can create the CloudFormation stack with our AWSIAMConfiguration file

```shell
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap.yaml 
```

This generates resources:

- The bootstrap user and group
- Intance profiles (control-plane, controllers and nodes)
- Some ManagedPolicies
- Other Roles

## Deploy the CAPA infraestructure provider

### Controller Authentication aws profile

The controller deployment needs baseline AWS authentication to the CAPA controller in order to be deployed.

If we have created a bootstrapUser, we must **create an Access key and save the to an aws profile** for it

```shell
aws configure --profile=bootstrap-capa
```

Then we must translate this credentials to the kubernetes cluster where we will deploy the CAPA provider. We assume it will be in a aws-bootstrap secret in the capa-system namespace.

```shell
export AWS_PROFILE=bootstrap-capa
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
kubectl create secret generic aws-bootstrap --from-literal=AWS_B64ENCODED_CREDENTIALS="${AWS_B64ENCODED_CREDENTIALS}" --namespace capa-system
```

> They act as default credentials. Later, it is typical to use identityRef as per cluster credentials (spec.identityRef in an AWSCluster resource).

### Deploy CAPA using Capi Operator

We can deploy the aws infraestructure provider this way

```yaml
apiVersion: operator.cluster.x-k8s.io/v1alpha2
kind: InfrastructureProvider
metadata:
  name: aws
  namespace: capa-system
spec:
  version: v2.10.0
  configSecret:
    name: aws-bootstrap
  # some optional features
  manager:
    featureGates:
      MachinePool: true
```

See more [here about optional features](11-features.md)
