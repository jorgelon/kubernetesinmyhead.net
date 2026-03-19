# DeploymentRuntimeConfig

`DeploymentRuntimeConfig` (`pkg.crossplane.io/v1beta1`) is a cluster-scoped
resource that customizes the runtime of `Provider` and `Function` packages.
By default, Crossplane deploys providers as Kubernetes `Deployments` with
auto-generated `ServiceAccounts` and `Services`. A `DeploymentRuntimeConfig`
lets you override those defaults without modifying the provider package itself.

Reference it from a `Provider` or `Function` via `runtimeConfigRef`:

```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws-s3
spec:
  package: xpkg.crossplane.io/crossplane-contrib/provider-aws-s3:v1.0.0
  runtimeConfigRef:
    name: my-runtime-config
```

Crossplane merges the template fields into the managed `Deployment`,
`ServiceAccount`, and `Service`. Fields not present in the template keep their
defaults.

## ServiceAccount

Use `serviceAccountTemplate` to set the name and annotations. Annotations are
the standard mechanism for cloud workload identity (IRSA, Azure Workload
Identity, GKE Workload Identity):

```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: aws-irsa
spec:
  serviceAccountTemplate:
    metadata:
      name: provider-aws
      annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/CrossplaneProviderAWS
```

> **Warning**: Setting `serviceAccountTemplate.metadata.name` causes Crossplane
> to take ownership of that `ServiceAccount`. To reuse a pre-existing account
> without Crossplane managing it, set
> `deploymentTemplate.spec.template.spec.serviceAccountName` instead.

## Deployment

Use `deploymentTemplate` to tune replicas, container resources, arguments,
node scheduling, or to inject extra containers. The provider container is always
named `package-runtime`:

```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: tuned
spec:
  deploymentTemplate:
    spec:
      replicas: 2
      selector: {}
      template:
        spec:
          containers:
            - name: package-runtime
              args:
                - --enable-external-secret-stores
              resources:
                requests:
                  memory: 256Mi
                limits:
                  memory: 512Mi
```

## Service

Use `serviceTemplate` to add labels or annotations to the `Service` Crossplane
creates for the provider's gRPC endpoint:

```yaml
apiVersion: pkg.crossplane.io/v1beta1
kind: DeploymentRuntimeConfig
metadata:
  name: custom-service
spec:
  serviceTemplate:
    metadata:
      labels:
        app.kubernetes.io/component: provider
```

## Key fields reference

| Field                                                                         | Description                                                       |
|-------------------------------------------------------------------------------|-------------------------------------------------------------------|
| `spec.deploymentTemplate.metadata`                                            | Labels/annotations on the `Deployment`                            |
| `spec.deploymentTemplate.spec.replicas`                                       | Number of replicas                                                |
| `spec.deploymentTemplate.spec.template.spec.containers[name=package-runtime]` | Provider container overrides (args, resources, env, volumeMounts) |
| `spec.deploymentTemplate.spec.template.spec.serviceAccountName`               | Reference an existing SA (no Crossplane ownership)                |
| `spec.deploymentTemplate.spec.template.spec.tolerations`                      | Pod tolerations                                                   |
| `spec.deploymentTemplate.spec.template.spec.nodeSelector`                     | Node selector labels                                              |
| `spec.serviceAccountTemplate.metadata.name`                                   | Override SA name (Crossplane takes ownership)                     |
| `spec.serviceAccountTemplate.metadata.annotations`                            | Annotations for workload identity                                 |
| `spec.serviceTemplate.metadata`                                               | Labels/annotations on the `Service`                               |
