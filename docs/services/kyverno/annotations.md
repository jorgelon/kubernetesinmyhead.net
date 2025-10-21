# Annotations

## policies.kyverno.io/title

Gives a title to the policy

```yaml
policies.kyverno.io/title: Disallow Capabilities
```

## policies.kyverno.io/description

Provides a brief description of what the policy does.

```yaml
policies.kyverno.io/description: >-
      An ingress resource needs to define an actual host name
      in order to be valid. This policy ensures that there is a
      hostname for each rule defined.
```

```yaml
policies.kyverno.io/description: "Ensure all Pods have resource limits defined."
```

## policies.kyverno.io/severity

Defines the severity level of the policy.
Possible values: low, medium, high

```yaml
policies.kyverno.io/severity: medium
```

## policies.kyverno.io/category

Categorizes the policy into a specific group or type.
Possible Values: security, compliance, best-practices, etc.

```yaml
policies.kyverno.io/category: security
```

## policies.kyverno.io/minversion

## policies.kyverno.io/subject

Specifies the subject of the policy (e.g., Pod, Namespace, Deployment).

```yaml
policies.kyverno.io/subject: Ingress
```

## policies.kyverno.io/controls

Maps the policy to specific compliance controls (e.g., CIS benchmarks, NIST standards).

```yaml
policies.kyverno.io/controls: "CIS-1.3.2, NIST-800-53"
```

## policies.kyverno.io/owner

Identifies the owner or team responsible for the policy.

```yaml
policies.kyverno.io/owner: "DevSecOps Team"
```

## policies.kyverno.io/scorecard

Indicates whether the policy is part of a compliance scorecard. While primarily used for compliance tracking, this annotation can be integrated into external tools or workflows to enforce compliance checks.
Useful in environments where compliance policies are tracked and enforced as part of governance.

```yaml
policies.kyverno.io/scorecard: "true"
```

## policies.kyverno.io/autogen-controllers

This is not an informative annotation. Specifies which controllers the policy applies to when auto-generating rules.

```yaml
policies.kyverno.io/autogen-controllers: "Deployment"
```

```yaml
policies.kyverno.io/autogen-controllers: "none"
```

See more here

- Auto-Gen Rules

<https://main.kyverno.io/docs/policy-types/cluster-policy/autogen/>

## kyverno.io/kyverno-version

Indicates the version of Kyverno that was used to create or apply the policy.

```yaml
kyverno.io/kyverno-version: 1.6.0
```

## kyverno.io/kubernetes-version

Indicates the version of Kubernetes that was in use when the policy was created or applied.

```yaml
kyverno.io/kubernetes-version: "1.22-1.23"
```
