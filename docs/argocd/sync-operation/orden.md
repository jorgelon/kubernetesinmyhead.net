# En que orden se aplican los recursos en una sincronizacion

Para ordenar la sincronizacion de los recursos, argocd tiene en cuenta varios factores. Ordenados de mayor a menor importancia, tenemos:

- la fase del recurso
- la wave del recurso
- el tipo de recurso
- el nombre del recurso

> Antes de iniciar la sincronizacion como tal, ArgoCD hace un dry-run

## Fases del recurso

ArgoCD cuenta con 3 fases de ejecucion:  

- Pre-Sync
- Sync
- Post-Sync

Por defecto, todos los objetos llevan la fase "Sync" pero es posible indicarla en el objeto con una de estas anotaciones:

- argocd.argoproj.io/hook: PreSync
- argocd.argoproj.io/hook: Sync
- argocd.argoproj.io/hook: PostSync

> Las fases PreSync y PostSync realmente se usan para especificar hooks, pensados mas para la ejecucion de tareas previas o posteriores a la sincronizacion.

## Waves del recurso

Las waves son una forma de ordenar los recursos dentro de una misma fase. Por defecto la wave de un recurso es 0, pero podemos cambiarla mediante la anotacion:

```txt
argocd.argoproj.io/sync-wave: "numero de wave"
```

El numero de wave puede ser positivo o negativo, donde los numeros negativos se aplican antes. Este seria un ejemplo de orden de waves:

```txt
-4
-1
0 (por defecto)
1
3
```

## Tipo de recurso

Dentro de una misma wave, argo cd tiene en cuenta el tipo de recurso a la hora de ordenarlos. El orden aplicado se puede ver aqui:

<https://github.com/argoproj/gitops-engine/blob/master/pkg/sync/sync_tasks.go>

> En este orden no estan, logicamente, los custom resources, es decir, tipos de objectos añadidos via custom resource definition, que seran aplicados al final de la wave

## El nombre del recurso

## Orden final

- Ejecucion de la fase Pre-Sync ordenando los recursos por numero de wave. Dentro de cada wave ordenados por tipo del recurso. Si dentro de esa wave hay recursos del mismo tipo, iran ordenados por nombre.

- Ejecucion de la fase Sync ordenando los recursos por numero de wave. Dentro de cada wave ordenados por tipo del recurso. Si dentro de esa wave hay recursos del mismo tipo, iran ordenados por nombre.

- Ejecucion de la fase PostSync ordenando los recursos por numero de wave. Dentro de cada wave ordenados por tipo del recurso. Si dentro de esa wave hay recursos del mismo tipo, iran ordenados por nombre.

## Reflexiones

- Sobre el estado de un recurso:
ArgoCD no pasa al siguiente punto del orden hasta que el anterior ha ido bien (health check). Y Argocd sabe cuando ha ido bien para los recursos base de kubernetes (deployments, jobs, servicios,...) y otros crd adicionales.
Para crds de los que no sabe como comprobar la salud, se pueden agregar health checks via lua scripts, de una forma bastante engorrosa.

## Links

- Sync and waves  
<https://argo-cd.readthedocs.io/en/stable/user-guide/sync-waves/>

- Hooks  
<https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/>

- Mastering Argo CD Sync Waves: A Deep Dive into Effective GitOps Synchronization Strategies  
<https://www.youtube.com/watch?v=LKuRtOTvlXk>

- Resource health  
<https://argo-cd.readthedocs.io/en/stable/operator-manual/health/>

- Resource health añadidos para custom resource definitions
<https://github.com/argoproj/argo-cd/tree/master/resource_customizations>
