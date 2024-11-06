# Prioridades entre pods

## Priority classes (scheduling)

El uso de priority classes es una herramienta para dar prioridades a pods a la hora de ser desplegados en un cluster de kubernetes. Mediante ellas, si un pod con una prioridad mas alta no puede ser desplegado, el scheduler intentara por defecto desalojar pods con prioridades mas bajas para hacerle hueco.

Por defecto, Kubernetes viene con 2 PriorityClass listas para ser asignadas a pods

- system-node-critical, con prioridad mayor, 2000001000
- system-cluster-critical, con prioridad 2000000000

Asi, en una priorityclass se  puede definir

- Una descripcion
- El numero que especifica la prioridad
- globalDefault:  
Para espeficar si es la priority class por defecto
- preemptionPolicy:  
Admite 2 valores: Con **Never** los pods con mas prioridad estaran en la cola antes que los de menos prioridad, pero no se liberaran recursos. Es decir, si no hay recursos para ellos seguiran en la cola sin ser desplegados hasta que se hayan liberado por otros metodos.
Con **PreemptLowerPriority**, que es el valor por defecto, se liberan recursos

> To preempt significa adelantarse

## Lista de algunas priority classes y como se crean

| Priority Class          | Value      | Deployer       |
|-------------------------|------------|----------------|
| system-node-critical    | 2000001000 | kubeadm        |
| system-cluster-critical | 2000000000 | kubeadm        |
| high-priority           | 100000000  | custom         |
| workflow-controller     | 1000000    | argo workflows |

## Lista de algunos workloads y sus default priority classes

| Workload                         | Default                 |
|----------------------------------|-------------------------|
| cilium Daemonset                 | system-node-critical    |
| ebs-csi-node Daemonset           | system-node-critical    |
| eks-pod-identity-agent Daemonset | system-node-critical    |
| argo workflow controller         | workflow-controller     |
| karpenter                        | system-cluster-critical |
| aws-load-balancer-controller     | system-cluster-critical |
| cilium-operator                  | system-cluster-critical |
| coredns                          | system-cluster-critical |
| karpenter                        | system-cluster-critical |
| ebs-csi-controller               | system-cluster-critical |
| node-exporter                    | system-cluster-critical |
| karpenter                        | system-cluster-critical |
| metrics server                   | system-cluster-critical |
| vsphere-csi-controller           | system-cluster-critical |

## Listar pods de una priorityclass

```shell
kubectl get pods -A -o json | jq -r '.items[] | select(.spec.priorityClassName=="system-cluster-critical") | .metadata.name + " in " + .metadata.namespace'
```

```shell
kubectl get pods -A -o json | jq -r '.items[] | select(.spec.priorityClassName=="system-node-critical") | .metadata.name + " in " + .metadata.namespace'
```

```shell
kubectl get pods -A -o json | jq -r '.items[] | select(.spec.priorityClassName=="high-priority") | .metadata.name + " in " + .metadata.namespace'
```

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
