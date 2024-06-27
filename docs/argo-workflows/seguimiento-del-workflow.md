# Seguimiento del workflow

Para seguir como va un workflow tenemos varias opciones

## Al finalizar el workflow (exit handler)

Para obtener como ha ido un workflow al terminar existe el exit handler, que no es mas que una llamada a un template y se define mediante el campo spec.onExit

Al terminar un workflow, se generan 2 variables:

- workflow.status:  
Puede ser Succeeded, Failed o Error

- workflow.failures:  
Es una lista de json con lo que ha fallado en el workflow

## Durante el workflow (LifecycleHook)

En un LifecycleHook se definen acciones a ejecutar cuando se cuando se cumple una condicion.

Estas condiciones pueden ser:

- Variables de exit handler: workflow.status y workflow.failures
- template
- templateRef
- arguments

> LifecycleHook se ejecuta antes que los outputs asi que solo pueden usarse los de steps anteriores

Se puede definir a nivel de workflow o a nivel de step dentro del campo "hooks"

> El nombre de un LifecycleHook no es importante, aunque si se le llama "exit" se convierte en un exit handler.

### Ejemplo a nivel de workflow

```yaml
spec:
  hooks:
    nombredelhook:
      expression: workflow.status == "Running"
      template: http
```

### Ejemplo a nivel de step o dag

```yaml
spec:
    entrypoint: main
    templates:
    - name: main
        steps:
        - - name: step-1
            hooks:
                nombredelhook:
                expression: steps["step-1"].status == "Running"
                template: http
                success:
                expression: steps["step-1"].status == "Succeeded"
                template: http
            template: echo
```

## Ejemplo con parameters

```yaml
spec:
  entrypoint: main
  templates:
    - name: main
      steps:
        - - name: step-1
            template: output
            hooks:
              exit:
                template: exit
                arguments:
                  parameters:
                    - name: message
                      value: "{{steps.step-1.outputs.parameters.result}}"
```

> La expresion no soporta `-` en el nombre de la variable, y debe usarse con `[]`

## Eventos de kubernetes

## Links

- Workflow notifications:  
<https://argo-workflows.readthedocs.io/en/stable/workflow-notifications/>

- Exit Handlers:  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/exit-handlers/>
<https://argo-workflows.readthedocs.io/en/latest/variables/#exit-handler>

- LifecycleHook
<https://argo-workflows.readthedocs.io/en/stable/lifecyclehook/>
<https://argo-workflows.readthedocs.io/en/stable/fields/#lifecyclehook>

- Kubernetes events:  
<https://argo-workflows.readthedocs.io/en/stable/workflow-events/>
