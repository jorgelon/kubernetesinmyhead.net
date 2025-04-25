# Templating

There are 2 ways to define the application template that an applicationset will create.

## Fast template

By default, an argocd applicationset uses fastemplate as template engine to define an application.

> According the argocd documentation, it will be deprecated

## Go text template

It will replace fast template and it must be activated in the applicationset definition with goTemplate: true.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: my appset
spec:
  goTemplate: true
  goTemplateOptions: ["missingkey=error"]
```

> The go text template is more powerful than the fast template.

### Sprig function library

In addition to the go template, also the Sprig function library can be used with goTemplate enabled

### goTemplateOptions

It is possible to add some goTemplateOptions
The recommendeed goTemplateOptions is ["missingkey=error"]. This makes the applicationset fail is a parameter defined in the template does not exist.

## Template Patch

pending

## Links

- fasttemplate

<https://github.com/valyala/fasttemplate>

- Templates

<https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Template/>

- Go Template

<https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/GoTemplate/>

- Go text template

<https://pkg.go.dev/text/template>

- Sprig function library

<https://masterminds.github.io/sprig/>
