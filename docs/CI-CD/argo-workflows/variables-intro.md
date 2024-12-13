# Variables: Intro

In Argo Workflows there 2 kinds of template tag, or ways to call a variable,

## Simple

The simple way is using this format

```txt
{{variable}}
```

There is simple substitution between the variable and the value

> The recommended way is not to leave spaces between the brackets

## Expression

But we can call the variable using an expression, with this format

```txt
{{=variable}}
```

In this case the value of the variable is the result of evaluating the tag as an expression.

There are some different things we can do using the expr language. In this example we extract data from a json

```txt
jsonpath(inputs.parameters.json, '$.some.path')
```

> If we hyphens in the tag we can have unexpected error. This can be related with parameters or steps. To solve it we can rename the parameter or step, or reference them by indexing into the parameter or step map.

```txt
inputs.parameters['my-param'] or steps['my-step'].outputs.result
```

In this example we can parse a json a using the key "password" as a parameter

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: test
spec:
  entrypoint: main
  templates:
    - name: http-post
      http:
        url: "https://{{workflow.parameters.harborUrl}}/api/v2.0/robots"
        method: POST
    - name: echo
      inputs:
        parameters:
          - name: password
      container:
        image: docker.io/alpine
        command: ["echo"]
        args: "{{inputs.parameters.username}}"
    - name: main
      steps:
        - - name: makeapicall
            template: http-post
        - - name: deploy-credentials
            template: write-secret
            arguments:
              parameters:
                - name: password
                  value: "{{=jsonpath(steps.makeapicall.outputs.result, '$.password')}}"
```

## Links

- Workflow Variables

<https://argo-workflows.readthedocs.io/en/stable/variables/>

- Expr Lang

<https://expr-lang.org/docs/language-definition>
