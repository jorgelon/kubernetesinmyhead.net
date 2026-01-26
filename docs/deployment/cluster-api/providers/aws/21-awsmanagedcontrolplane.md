# AWSManagedControlPlane

This resource configures the eks cluster and it has several sections that translate the eks api to the resource

## spec.identityRef

This field is the credentials to use when reconciling the managed control plane.

If no identity is specified, the default identity for this controller will be used.

Here we can use 3 identity types (spec.identityRef.kind)

### AWSClusterControllerIdentity

This authentication method uses the controller credentials. The AWSClusterControllerIdentity resource permits to filter what namespaces can call it.

> Currently only the name "default" is valid (CAPA controllers use only one credentials).

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AWSClusterControllerIdentity
metadata:
  name: default
spec:
  allowedNamespaces:
    list:
      - demo-capi
```

## AWSClusterStaticIdentity

This authentication method uses static credentials stored in a kubernetes secret that contains the following keys:

- AccessKeyID
- SecretAccessKey

It can also be filtered by permitted namespace

```yaml
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSClusterStaticIdentity
metadata:
  name: "test-account"
spec:
  secretRef:
  allowedNamespaces:
    list:
      - demo-capi
```

### AWSClusterRoleIdentity

This authentication method uses the STS::AssumeRole API

## Links

- Multi-tenancy

<https://cluster-api-aws.sigs.k8s.io/topics/multitenancy>

- Multitenancy setup with EKS and Service Account

<https://cluster-api-aws.sigs.k8s.io/topics/full-multitenancy-implementation>
