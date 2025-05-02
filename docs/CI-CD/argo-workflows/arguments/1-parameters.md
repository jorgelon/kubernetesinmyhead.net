# Parameters intro

## Global parameters (arguments)

We can define global parameters at workflow level (arguments) and they are passed to the entrypoint template.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: myworkflow
spec:
  arguments:
    parameters:
      - name: param1
      - name: param2
```

They can be used inside the templates as variables :

```txt
"{{workflow.parameters.param1}}"
"{{workflow.parameters.param2}}"
```

!!! note
If we want to provide values to a global parameter, we must pass them there (spec.arguments.parameter.parameter.value)

> "{{workflow.parameters.json}}" is also a variable with all the parameters as a json string

## Local scoped parameters (inputs)

We can also define parameters at template level as inputs. They are local scoped parameters.

A template defines inputs which are then provided by template callers (such as steps, dag, or even a workflow).

As inputs

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  name: myworkflow
spec:
  entrypoint: main
  templates:
    - name: main
      inputs:
        parameters:
          - name: param1
          - name: param2
```

They can be used inside the templates as:

```txt
"{{inputs.parameters.param1}}"
"{{inputs.parameters.param2}}"
```

!!! note
If we want to provide values to a local parameter, we can make it template caller level, input level and workflow level. [See this](2-resolved.md)

> "{{inputs.parameters.json}}" is also a variable with all the parameters as a json string

## Notes

- If you want to use a parameter in some templates, declare it at spec level and consume it with "{{workflow.parameters.param1}}"
- If you want to use a parameter only in one template, declare it at template level and consume it with "{{inputs.parameters.param1}}"
- In containerset, container and script templates, inputs and outputs can only be loaded a saved from a template called main.
