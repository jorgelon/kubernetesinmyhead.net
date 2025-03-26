# Path and pathType

## path

pending

## pathType

pathType defines what calls will be matched by this rule and we can choose between 3 options:

### Exact

This matches the exact URL

### Prefix

This matches an URL that starts with the configured path using / as separator of subpaths

This example matches /path/subpath, /path/subpath/another1, /path/subpath/another2 but not /path/subpathanother3

```txt
path: /path/subpath 
pathType: Prefix
```

### ImplementationSpecific

This leaves the path matching to the ingress controller. Depending of the ingress controller, it can treat it as Prefix or Exact
This path type provides flexibility for Ingress controllers to implement custom path-matching rules that may not conform to the standard Exact or Prefix types.
In the other hand, the same ingress resource is not guaranteed to be consistent across different controllers.

## Links

- Ingress v1 spec

<https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/>
