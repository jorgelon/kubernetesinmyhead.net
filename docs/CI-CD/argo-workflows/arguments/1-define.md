# Define parameters

## Global parameters (arguments)

We can define global parameters at workflow level

- They are located inside arguments section
- When the workflow is called fully (not calling a template) They and they are passed to the entrypoint template.

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
  templates:
    - name: mytemplate
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
If we want to provide values to a local parameter, we can make it using template caller (dag, steps) level, input level and workflow level. [See this](2-resolve.md)

> "{{inputs.parameters.json}}" is also a variable with all the parameters as a json string

## Notes and suggestions

- In containerset, container and script templates, inputs and outputs can only be loaded a saved from a template called main.

- Because there are 3 ways to call One suggestion is to define a parameter that can be used in more than one template in both places, at spec level (argument) and at template level (inputs)
