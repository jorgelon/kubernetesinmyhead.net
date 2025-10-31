# Resource templating

This tools permit to group some kubernetes resources in templates and create instances with different values

## List of tools

| Name          | How it defines                                             | Link                                  |
|---------------|------------------------------------------------------------|---------------------------------------|
| Helm          | Go templates with values, charts, and helpers              | <https://helm.sh/docs/>               |
| Kustomize     | Overlays, patches (strategic merge, JSON), and components  | <https://kustomize.io/>               |
| Crossplane    | Composite Resource Definitions (XRDs) and Compositions     | <https://docs.crossplane.io/>         |
| Kro           | ResourceGraphDefinition CRD with CEL expressions           | <https://kro.run/docs>                |
| Ytt           | YAML templating with overlays                              | <https://carvel.dev/ytt/docs/latest/> |
| KCL lang      | Constraint-based configuration language                    | <https://www.kcl-lang.io/>            |
| Timoni        | CUE language with modules and bundles                      | <https://timoni.sh/quickstart/>       |
| Kubevela      | OAM Application CRD with components and traits             | <https://kubevela.io/docs/>           |
| KPT           | Declarative configuration with functions                   | <https://kpt.dev/>                    |
| Grafana Tanka | Jsonnet with ksonnet libraries                             | <https://tanka.dev/>                  |
| Operator SDK  | Custom Resource Definitions with Go/Ansible/Helm operators | <https://sdk.operatorframework.io/>   |
| CDK8s         | Object-oriented APIs in TypeScript, Python, Java, Go       | <https://cdk8s.io/>                   |

## Recommended

- Helm: For using 3rd party applications or provide internal applications to external users
- Kustomize: for internal applications
- Ytt: for internal applications
- Crossplane: for platform engineering
