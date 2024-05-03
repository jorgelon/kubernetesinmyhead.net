Los "parameters" son un tipo de "arguments" y se pueden definir en 2 sitios:

# A nivel de workflow spec

```
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: hello-world-parameters-
spec:
  entrypoint: main
  arguments:
    parameters:
    - name: message
      value: "hello"  # opcional
```
Este parametro se pasa al template del entrypoint y se consume en dicho template mediante un input

```
  templates:
  - name: main
    inputs:
      parameters:
      - name: message       # parameter declaration
    container:
      image: docker/whalesay
      command: [cowsay]
      args: ["{{inputs.parameters.message}}"]
```

Esto genera la variable {{workflow.parameters.message}} con el valor del parametro message y son "globally scoped" asi que puede usarse en varios templates


# Dentro de un template de tipo step o dag
```
...
spec:
  templates:
  - name: main
    dag:
      tasks:
      - name: step-A
          template: step-template-a
          arguments:
            parameters:
            - name: template-param-1
                value: abcd
  ```

> en containerset, container y script inputs and outputs can only be loaded and saved from a container named main.

# Links

- Parameters  
https://argo-workflows.readthedocs.io/en/stable/walk-through/parameters/

- Inputs  
https://argo-workflows.readthedocs.io/en/stable/workflow-inputs/