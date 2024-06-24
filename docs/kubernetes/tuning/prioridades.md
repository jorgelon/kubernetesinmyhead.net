# Prioridades entre pods

## Priority classes (scheduling)

El uso de priority classes es una herramienta para dar prioridades a pods en un cluster de kubernetes. Mediante ella, si un pod con una prioridad mas alta no puede ser desplegado, el scheduler intentara por defecto desalojar pods con prioridades mas bajas para hacerle hueco.

Por defecto, Kubernetes viene con 2 PriorityClass listas para ser asignadas a pods

- system-cluster-critical, con prioridad 2000000000
- system-node-critical, con proridad mayor, 2000001000

Ademas del numero que especifica la prioridad y una descripcion, se pueden definir:

- globalDefault: si es la priority class por defecto
- preemptionPolicy

### preemptionPolicy

preemptionPolicy admite 2 valores:

- Never
Con este valor, los pods con mas prioridad estaran en la cola antes que los de menos prioridad, pero no se liberaran recursos. Es decir, si no hay recursos para ellos seguiran en la cola sin ser desplegados hasta que se hayan liberado por otros metodos.

- PreemptLowerPriority
Es el valor por defecto. Se liberan recursos

> To preempt significa adelantarse

## Quality of Service Classes

## Links

- Pod Priority and Preemption  
<https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/>

- Guaranteed Scheduling For Critical Add-On Pods  
<https://kubernetes.io/docs/tasks/administer-cluster/guaranteed-scheduling-critical-addon-pods/>

- PriorityClass spec  
<https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/priority-class-v1/>

- Pod Quality of Service Classes  
<https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/>
<https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/>

- Node Pressure Eviction  
<https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/>
