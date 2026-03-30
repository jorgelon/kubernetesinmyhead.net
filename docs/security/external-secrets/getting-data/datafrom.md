# dataFrom in external secret

dataFrom is a way to get secrets from the secrets provider and it is used when we want to fetch all the keys from the provider with the ability to do some filters.

It is an array with entries with "sourceRef" as mandatory field and, optionally, "extract", "find" and "rewrite".

> If multiple entries are specified, the Secret keys are merged in the specified order

## sourceRef

First of all we need to setup the secret store, cluster secret store o generator to obtain the data

SourceRef points to a store or generator which contains secret values ready to use. Use this in combination with Extract or Find pull values out of a specific SecretStore. When sourceRef points to a generator Extract or Find is not supported. The generator returns a static map of values

SourceRef allows you to override the source from which the secret will be pulled from. You can define at maximum one property.

Example: Using a secret store

```yaml
  dataFrom:
  - sourceRef:
      storeRef:
        name: mysecretstore
        kind: SecretStore # default
```

Example: Using a cluster secret store

```yaml
  dataFrom:
  - sourceRef:
      storeRef:
        name: myclustersecretstore
        kind: ClusterSecretStore
```

Example: Using a generator

When sourceRef points to a generator, extract or find is not supported.

```yaml
  dataFrom:
  - sourceRef:
      generatorRef:
        apiVersion: generators.external-secrets.io/v1alpha1
        kind: ECRAuthorizationToken
        name: "my-ecr"
```

## extract (optional)

Used to extract multiple key/value pairs from one secret

mandatory field: key

Key is the key used in the Provider, mandatory

optional fields:

- metadataPolicy
- property
- version
- conversionStrategy
- decodingStrategy

Documentation about extract

<https://external-secrets.io/latest/guides/all-keys-one-secret/>

## find (optional)

Used to create a secret in kubernetes from several secrets in the provider. With find we fetch them based on certain criteria like "path", "name" and "tags". We can use them when needed combined in the same "find" field.

- path
Specifies a root path to start the find operations. It is only supported in some providers.

```yaml
  dataFrom:
  - find:
      path: path-to-filter
```

- name
Finds secrets based on the name and an **optional regular expression**

```yaml
  dataFrom:
  - find:
      name:
        regexp: ".*myfilter.*"
```

- tags
Find secrets based on tags

```yaml
  dataFrom:
  - find:
      tags:
        environment: "prod"
        application: "app-name"
```

Another optional fields:

- conversionStrategy
- decodingStrategy

Documentation about find:

<https://external-secrets.io/latest/guides/getallsecrets/>

## rewrite (optional)

Used to rewrite secret Keys after getting them from the secret Provider Multiple Rewrite operations can be provided. They are applied in a layered order (first to last)

### regexp

Used to rewrite with regular expressions. The resulting key will be the output of a regexp.ReplaceAll operation.

- source
Used to define the regular expression of a re.Compiler.

- target
Used to define the target pattern of a ReplaceAll operation.

### transform

Used to apply string transformation on the secrets. The resulting key will be the output of the template applied by the operation.

- template:
Used to define the template to apply on the secret name. .value will specify the secret name in the template.

Documentation about rewrite:

<https://external-secrets.io/latest/guides/datafrom-rewrite/>

## dataFrom array

| entry         |                                                                         |                |
|---------------|-------------------------------------------------------------------------|----------------|
| sourceRef     | storeRef                                                                |                |
| sourceRef     | generatorRef                                                            |                |
| extract       | key (m)                                                                 |                |
| extract other | metadataPolicy, property, version, conversionStrategy, decodingStrategy |                |
| find          | path                                                                    |                |
| find          | name                                                                    | regexp         |
| find          | tags                                                                    |                |
| find other    | conversionStrategy, decodingStrategy                                    |                |
| rewrite       | regexp                                                                  | source, target |
| rewrite       | transform                                                               | template       |

## Links

- ExternalSecretDataFromRemoteRef

<https://external-secrets.io/latest/api/spec/#external-secrets.io/v1beta1.ExternalSecretDataFromRemoteRef>

- External secret

<https://external-secrets.io/latest/api/externalsecret/>
