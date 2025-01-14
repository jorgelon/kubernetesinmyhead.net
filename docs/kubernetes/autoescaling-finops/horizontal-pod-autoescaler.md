# Horizontal pod autoescaler  

## Definir que queremos escalar

Se hace mediante spec.scaleTargetRef

```yaml
    scaleTargetRef:
      apiVersion: apps/v1
      kind: Deployment
      name: mideployment
```

## Replicas deseadas

Se hace mediante:

- spec.minReplicas
- spec.maxReplicas

## Donde buscar la metrica

Al definir una metrica de escalado, debemos definir mediante "type" donde mirar

- Resource:
Con Resource se mira el uso de requests de cpu o memoria de los contenedores de un pod

- ContainerResource
Con ContainerResource, estable desde kubernetes 1.30 mirara el uso de requests de cpu o memoria de un contenedor individual dentro de un pod

- Pods
Pods permite utilizar custom metrics

- External
Para usar metricas externas a kubernetes

- Object
Object mirara en un objeto de kubernetes

## Escalados

### En base al porcentaje de uso de requests

Con **target.type: Utilization y averageUtilization** podemos especificar **un numero** que sera un **porcentaje del uso de resource requests** (cpu y/o memoria). HPA intentara mantener ese porcentaje mediante el escalado.

> Solo esta soportado para ContainerResource y Resource

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nombredelhpa
spec:
  metrics:
  - resource:
      name: memory
      target:
        averageUtilization: 70 # media de un 70% de los requests de memoria
        type: Utilization
    type: Resource
```

### En base a un promedio

Con **target.type: AverageValue + averageValue** podemos especificar **un quantity** como una media de un valor de la metrica. HPA intentara mantener ese valor promedio mediante el escalado.

En el caso de recursos de pods, sera bytes para memoria y milicores para CPU.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nombredelhpa
spec:
  metrics:
  - resource:
      name: cpu
      target:
        averageValue: 500 # media de 500 milicores
        type: AverageValue
    type: Resource
```

### En base a un valor absoluto

Con **target.type: Value + value**  definimos un **un quantity** como un **valor absoluto** de la metrica. HPA intentara mantener ese valor mediante el escalado.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: nombredelhpa
spec:
  metrics:
  - resource:
      name: cpu
      target:
        value: 2 # uso de 2 cpus sumando los pods
        type: Value
    type: Resource
```

## Behaviour

Con spec.behaviour se puede controlar la frecuencia y velocidad de escalado y desescalado

### stabilizationWindowSeconds

Con stabilizationWindowSeconds se puede reducir la frecuencia de escalado o desescalado cuando las metricas cambian. Con este valor, se definen una ventana de valores que se tendran en cuenta a la hora del escalado o desescalado.

> El valor puede ser desde 0 (no hay estabilzacion) hasta 3600 (un dia). Por defecto, al escalar hacia arriba el valor es 0 (no hay estabilizacion) y al escalar hacia abajo 300.

### Policies

Con las policies se pueden definir una serie de posibles politicas de escalado.

```yaml
behavior:
  scaleDown:
    policies:
    - type: Pods # this permits to scale down 3 replicas in 2 minutes
      value: 3
      periodSeconds: 120
    - type: Percent # this permits at most 20% of the current replicas to be scaled down in 3 minutes
      value: 20
      periodSeconds: 180
```

Si hay varias politicas definidas, por defecto se aplica la que permite mas cambios. Con selectPolicy se puede cambiar este comportamiento y elegir que politica usar.

## Links

- Horizontal Pod Autoscaling

<https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/>

- HorizontalPodAutoscaler Walkthrough

<https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/>

- autoscaling/v2 API

 <https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/horizontal-pod-autoscaler-v2/>
