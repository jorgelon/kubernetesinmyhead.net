# Parameters en arguments e inputs

En Argo Workflows se pueden pasar datos a un workflow o template usando arguments e inputs.
Ademas, esto datos que se pueden pasar pueden ser a su vez parameters y artifacts, es decir:

```txt
arguments:
  - parameters
  - artifacts
inputs:
  - parameters
  - artifacts
```

Aqui hablare de los parameters

## Parameters como Arguments (global parameters)

Los parametros se pueden definir como arguments a nivel de workflow y a nivel de template caller (dag o steps).

Los parametros definidos a nivel de workflow spec:

- Se pasan a la plantilla definida como entrypoint
- Generan la variable global {{workflow.parameters.parametro}} con el valor del parametro
- Son "globally scoped" asi que puede usarse en varios templates.

> workflow.parameters.json ademas es una variable con todos parameters presentados como un json string

Ejemplo a nivel de workflow spec:

```yaml
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

Ejemplo dentro de un template caller (step o dag):

```yaml
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

## Parameters como Inputs (local parameters)

Los inputs se definen de forma local dentro de un template y generan la variable inputs.parameters.parametro con el valor del parametro

> inputs.parameters.json ademas es una variable con todos los input parameters a un template como un json string (por confirmarse)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: arguments-parameters-
spec:
  entrypoint: whalesay
  arguments:
    parameters:
    - name: message
      value: hello world
  templates:
    - name: whalesay
        inputs:
          parameters:
            - name: message
        container:
          image: docker/whalesay:latest
          command: [cowsay]
          args: ["{{inputs.parameters.message}}"]
```

> En templates de tipo containerset, container y script, los inputs y outputs solo pueden ser cargados y guardados desde un container llamado main.

## Output parameters

## Links

- Parameters  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/parameters/>

- Parameters spec  
<https://argo-workflows.readthedocs.io/en/stable/fields/#parameter>

- Inputs  
<https://argo-workflows.readthedocs.io/en/stable/workflow-inputs/>

- Intermediate parameters  
<https://argo-workflows.readthedocs.io/en/latest/intermediate-inputs/>

- Parameters in workflow templates  
<https://argo-workflows.readthedocs.io/en/latest/workflow-templates/>
