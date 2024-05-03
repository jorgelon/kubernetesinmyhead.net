# Como llamar desde un workflow a templates

Un workflow puede incluir templates que llaman a otro templates, usando los template callers (dag y steps)

## Usando template callers dentro del mismo workflow

Mediante dag y steps se puede llamar a otros templates definidos en el mismo workflow.  
Para ello se define la template referenciables, y luego es llamada desde el caller

- Steps  
<https://argo-workflows.readthedocs.io/en/latest/walk-through/steps/>

- Dag  
<https://argo-workflows.readthedocs.io/en/latest/walk-through/dag/>

## Usando templateRef con referencias a (Cluster)WorkflowTemplate

Otra forma usando callers (dag y steps) es referenciar a un (Cluster)WorkflowTemplate templateRef  
Se debe indicar:

- el nombre del workflowtemplate
- el nombre del template dentro de el
- si es clusterscoped (clusterworkflowtemplate) o no (workflowtemplate)

Ejemplos:

- Con Steps

```yaml
spec:
  ...
  templates:
    - name: whalesay
      steps:
        - - name: hello-world
            templateRef:
              name: hello-world-template-global-arg
              template: hello-world
              clusterScope: true
```

- Con Dag

```yaml
spec:
  ...
  templates:
  - name: whalesay
    dag:
      tasks:
        - name: call-whalesay-template
          templateRef:
            name: workflow-template-1
            template: whalesay-template
```

## Usando workflowTemplateRef

Es una forma sencilla de instanciar un (Cluster)WorkflowTemplate. Se define a nivel de spec

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: cluster-workflow-template-hello-world-
spec:
  entrypoint: whalesay-template
  workflowTemplateRef:
    name: cluster-workflow-template-submittable
    clusterScope: true
```

## Links

- Sobre workflow templates  
<https://argo-workflows.readthedocs.io/en/latest/workflow-templates/>

- Sobre cluster workflow templates  
<https://argo-workflows.readthedocs.io/en/latest/cluster-workflow-templates/>

- Spec sobre templateref  
<https://argo-workflows.readthedocs.io/en/latest/fields/#templateref>

- Spec sobre workflowtemplateref  
<https://argo-workflows.readthedocs.io/en/latest/fields/#workflowtemplateref>
