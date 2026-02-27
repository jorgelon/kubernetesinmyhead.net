# Production tips

## Installation Id

Settings location: argocd-cm Configmap

Optional installation id. Allows to have multiple installations of Argo CD in the same cluster.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  installationID: "my-unique-id"
```

If you are managing one cluster using multiple Argo CD instances, you will need to set
`installationID` in the Argo CD ConfigMap. This will prevent conflicts between the different
Argo CD instances:

- Each managed resource will have the annotation `argocd.argoproj.io/installation-id: <installation-id>`
- It is possible to have applications with the same name in Argo CD instances without causing conflicts.
