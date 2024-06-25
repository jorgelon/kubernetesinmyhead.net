# Control de timeouts y limpieza

## Timeouts

El timeout de un workflow se configura mediante el valor spec.activeDeadlineSeconds, en el cual se especifica el valor en segundos tras el cual el workflow es terminado.
Aplicar "0" a uno en ejecucion, lo termina en el momento.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: timeouts-
spec:
  activeDeadlineSeconds: 10
```

Tambien puede aplicarse a nivel de template

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: timeouts-
spec:
  entrypoint: sleep
  templates:
  - name: sleep
    activeDeadlineSeconds: 10
```

## TTLStrategy

La TTLStrategy permite configurar el borrado programado de workflows que ya han terminado

Admite 3 valores:

- secondsAfterCompletion: numero de segundos a mantener tras completarse
- secondsAfterFailure: numero de segundos a mantener un workflow Failed
- secondsAfterSuccess: numero de segundos a mantener un workflow Succeeded

Si mezclas secondsAfterCompletion con secondsAfterFailure y secondsAfterSuccess, estos 2 ultimos tienen preferencia

## PodGC

PodGC permite borrar los pods una vez que se han completado

Primero se debe establecer una politica mediante "**strategy**", que puede tener estos valores:

- "OnPodCompletion" borra los pods cuando el pod se ha completado (incluyendo fallidos)
- "OnPodSuccess"  borra los pods cuando el pod es successful
- "OnWorkflowCompletion" borra los pods cuando el workflow se completa
- "OnWorkflowSuccess" borra los pods cuando el workflow es successful
- No configurar nada. Valor por defecto. No se borran los pods

**deleteDelayDuration** es un string donde se especifica la duracion antes de que los pods en la cola GC sean borrados. El valor por defecto es 5s

Mediante **labelSelector** se pueden filtar que pods se quieren borrar en base a labels

## Workflow defaults

Estas configuraciones pueden meterse en un el configmap workflow-controller-configmap como valores por defecto para los workflows

```yaml
  workflowDefaults: |
    spec:
      activeDeadlineSeconds: 1200
      ttlStrategy:
        secondsAfterCompletion: 86400
        secondsAfterFailure: 86400
        secondsAfterSuccess: 28800
      podGC:
        strategy: OnPodCompletion
        deleteDelayDuration: 86400s
```

## CronWorkflow history limits

Es posible controlar el borrado de workflows programados:

- successfulJobsHistoryLimit: numero de workflows terminados con exito que se guardan. Por defecto 3
- failedJobsHistoryLimit: numero de workflows fallidos que se guardan. Por defecto 1.

## Links

- Cost optimization  
<https://argo-workflows.readthedocs.io/en/stable/cost-optimisation/#limit-the-total-number-of-workflows-and-pods>

- Timeouts  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/timeouts/>

- Default workflow spec  
<https://argo-workflows.readthedocs.io/en/stable/default-workflow-specs/>

- Template defaults  
<https://argo-workflows.readthedocs.io/en/stable/template-defaults/>
