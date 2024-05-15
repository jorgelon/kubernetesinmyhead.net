# Tipos de templates

Este articulo trata sobre los tipos de templates que se pueden utilizar en argo workflows. Los templates vienen a ser como funciones y no deben ser confundidos con (Cluster)WorkflowTemplates. Nos referimos a lo que podemos definir justo debajo y a la altura de "name"

```yaml
spec:
  templates:
    - name: my-template
```

## Basicos

- container  
Se ejecuta un container, definiendo la imagen, argumentos, ...

- script  
Lo mismo, pero ejecutando un script dentro del container

- containerSet  
Igual que container o script, pero podemos definir varios containers a ejecutar en un pod  
<https://argo-workflows.readthedocs.io/en/stable/container-set-template/>

## Integrar, ordenar otros templates, template invocators, template caller

- steps  
Se definen pasos como una lista de listas. Los steps
<https://argo-workflows.readthedocs.io/en/stable/walk-through/steps/>

- dag  
Permite definir tareas con dependencias
<https://argo-workflows.readthedocs.io/en/stable/walk-through/dag/>

## Otros

- data  
Toma un origen de datos y lo transforma  
<https://argo-workflows.readthedocs.io/en/stable/data-sourcing-and-transformation/>

- http  
Hace una peticion http  
<https://argo-workflows.readthedocs.io/en/stable/http-template/>

- suspend  
Deja en suspenso el workflow  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/suspending/>

- resource  
Crea, actualiza o borra un recurso de kubernetes  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/kubernetes-resources/>

## Links

- Core concepts  
<https://argo-workflows.readthedocs.io/en/stable/workflow-concepts/>  

- Reference  
<https://argo-workflows.readthedocs.io/en/stable/fields/#template>
