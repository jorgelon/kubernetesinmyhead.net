> Nos referimos a lo que podemos definir aqui, justo debajo y a la altura de "name"

```
spec:
  templates:
    - name: my-template
```

# Basicos

- container  
Se ejecuta un container, definiendo la imagen, argumentos, ...

- script  
Lo mismo, pero ejecutando un script dentro del container

- containerSet  
Igual que container o script, pero podemos definir varios containers a ejecutar en un pod  
https://argo-workflows.readthedocs.io/en/latest/container-set-template/

# Integrar, ordenar otros templates, template invocators, template caller,...

- steps  
Se definen pasos como una lista de listas. Los steps 
https://argo-workflows.readthedocs.io/en/latest/walk-through/steps/

- dag  
Permite definir tareas con dependencias
https://argo-workflows.readthedocs.io/en/latest/walk-through/dag/

# Otros

- data  
Toma un origen de datos y lo transforma  
https://argo-workflows.readthedocs.io/en/latest/data-sourcing-and-transformation/

- http  
Hace una peticion http  
https://argo-workflows.readthedocs.io/en/latest/http-template/

- suspend  
Deja en suspenso el workflow  
https://argo-workflows.readthedocs.io/en/latest/walk-through/suspending/

- resource  
Crea, actualiza o borra un recurso de kubernetes  
https://argo-workflows.readthedocs.io/en/latest/walk-through/kubernetes-resources/

# Links
- Core concepts  
https://argo-workflows.readthedocs.io/en/latest/workflow-concepts/  

- Reference  
https://argo-workflows.readthedocs.io/en/latest/fields/#template
