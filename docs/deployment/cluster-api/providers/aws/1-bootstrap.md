# Bootstrap

We will bootstrap CAPA via cluster api operator. First of all we need to create all the necessary IAM resources needed for CAPA to manage AWS infrastructure.

To do this we will use the **clusterawsadm** binary a AWSIAMConfiguration configuration file, that will create a **CloudFormation stack** named cluster-api-provider-aws-sigs-k8s-io (by default) and includes:

- iam roles
- iam policies
- instance profiles

## Environment variables

We need the following environment variables to create the stack

```txt
AWS_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN (if using Multi-factor authentication)
```

## AWSIAMConfiguration file

We can configure the bootstrap with a AWSIAMConfiguration file. This yaml file contains different sections:

### bootstrapUser

Creates a dedicated IAM user and group with proper permissions for bootstrapping and managing Cluster API AWS Provider resources. THis avoid using personal AWS credentials and permit multitenancy scenarios.

Later we can generate access keys for this user and use them when running **clusterawsadm bootstrap credentials encode-as-profile**

> If the username and groupnames are not specified, bootstrapper.cluster-api-provider-aws.sigs.k8s.io will be used

### eks

Eks is enabled by default but some additional settings can be specified.

One of this setting is **spec.eks.iamRoleCreation**. By default all EKS clusters share the same IAM roles. Enabling it permits to separate iam roles per Eks cluster what provides better security isolation between clusters and per-cluster IAM customization.

> Enabling it permits to create roles per cluster, but if we want to create them we must enable the feature CAPA_EKS_IAM when deploying the provider

Example AWSIAMConfiguration

```yaml
apiVersion: bootstrap.aws.infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSIAMConfiguration
spec:
  bootstrapUser:
    enable: true
  eks:
    iamRoleCreation: true 
```

See this for more information and options available

- <https://cluster-api-aws.sigs.k8s.io/topics/using-clusterawsadm-to-fulfill-prerequisites>
- <https://cluster-api-aws.sigs.k8s.io/crd/>

## Create CloudFormation stack

Now we can create the CloudFormation stack

```shell
clusterawsadm bootstrap iam create-cloudformation-stack --config bootstrap.yaml 
```

This generates resources:

- The bootstrapper.cluster-api-provider-aws.sigs.k8s.io user and group
- Intance profiles (control-plane, controllers and nodes)
- Some ManagedPolicies
- Other Roles

## Get the credentials spec.configSecret

The controller deployment needs baseline AWS authentication in order to be deployed. We will give the **bootstrapper.cluster-api-provider-aws.sigs.k8s.io user** credentials for the CAPA controller.

- Create an Access key and save the to a profile

```shell
aws configure --profile=bootstrap-capa
```

And store it in a secret before deploying the provider

```shell
export AWS_PROFILE=bootstrap-capa
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
kubectl create secret generic aws-bootstrap --from-literal=AWS_B64ENCODED_CREDENTIALS="${AWS_B64ENCODED_CREDENTIALS}" --namespace capa-system
```

> They act as default credentials. Later, it is typical to use identityRef as per cluster credentials (spec.identityRef in an AWSCluster resource).

## Deploy CAPA using Capi Operator

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

We will deploy the aws capi infraestructure provider using capi operator, in the capa-system namespace

See here about optional features

- <https://cluster-api-aws.sigs.k8s.io/topics/eks/enabling>
- <https://cluster-api-aws.sigs.k8s.io/topics/reference/reference.html?highlight=featu#table-of-feature-gates-and-their-corresponding-environment-variables>
