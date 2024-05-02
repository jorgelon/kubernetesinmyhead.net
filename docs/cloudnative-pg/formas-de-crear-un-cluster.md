Hay varias formas de crear un cluster (bootstrap) de cloudnative PG

# Sin seccion bootstrap

Si en la definicion del cluster no hay una seccion bootstrap, el operador usara la siguiente configuracion por defecto:

```
spec:
    bootstrap:
        initdb:
            database: app
            owner: app
```
Lo que se traduce en que crea una base de datos llamada app con un usuario app como propietario.

> Siempre se crea una base de datos adicional llamada postgres

# Con seccion bootstrap - initdb y bbdd vacia

Como hemos visto, realmente initdb es la opcion por defecto y supone empezar una base de datos vacia.  
Para ello podemos especificar, entre otras cuestiones, el nombre de la base de datos a crear y el propietario

```
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cluster-example-initdb
spec:
  bootstrap:
    initdb:
      database: mibbdd
      owner: miowner
```
# Con seccion bootstrap - initdb e importando una bbdd

Supone iniciar una base de datos importando una de un cluster ya existente que este levantado, este o no en kuberntes. Para ello se vale de pg_dump y pg_restore.  
> Tambien es util para importar una base de datos a una version mayor de postgresql

La importacion se hace buscando un snapshot consistente de la bbdd de origen. Se recomienda parar las escrituras en origen.

## Tipos de importacion: microservicios y monolitico

La importacion de tipo microservicio esta pensado para importar una sola bbdd
La importacion monolith permite especificar un conjunto de bbdd y roles para ser importados

En la misma seccion initdb se debe especificar:
- el tipo de importacion (microservice|monolith)
- el external cluster de origen
- las bases de datos a importar. en el tipo microservice solo puede indicarse una
- opcionalmente sentencias sql a lanzar tras la importacion (postImportApplicationSQL)

```
spec:
  bootstrap:
    initdb:
      import:
        type: microservice
        databases:
          - mibbdd
        source:
          externalCluster: miexternacluster
  externalClusters:
    - name: miexternacluster
...
```
o bien

```
spec:
  instances: 3
  bootstrap:
    initdb:
      import:
        type: monolith
        databases:
          - bbdd1
          - bbdd2
          - bbdd3
        roles:
          - role1
          - role2
        source:
          externalCluster: miexternacluster
  externalClusters:
    - name: miexternacluster
...
```
# Con seccion bootstrap - recovery desde un backup fisico

Se parte de un backup ya existente

## partiendo de un object storage (opcion recomendada)

Esta opcion en mediante un backup hecho via via barmanObjectStore y definido en externalClusters

```
spec:
  bootstrap:
    recovery:
      source: clusterBackup
  externalClusters:
    - name: clusterBackup
      barmanObjectStore:
        destinationPath: https://STORAGEACCOUNTNAME.blob.core.windows.net/CONTAINERNAME/
        azureCredentials:
...
```

## Via volume snapshot

Se recomienda tener una version al menos de 1.21 del operator

```
spec:
  bootstrap:
    recovery:
      volumeSnapshots:
        storage:
          name: <snapshot name>
          kind: VolumeSnapshot
          apiGroup: snapshot.storage.k8s.io
        walStorage:
          name: <snapshot name>
          kind: VolumeSnapshot
          apiGroup: snapshot.storage.k8s.io
...
```
## Via objeto backup 

Tambien se puede tirar de un objeto de tipo backup en el mismo namespace

```
spec:
  instances: 3
  bootstrap:
    recovery:
      backup:
        name: backup-example
  storage:
    size: 1Gi
...
```
# Con seccion bootstrap - pg_basebackup 

Este modo sirve para crear un cluster nuevo como una replica exacta. El origen puede ser una copia de escritura o lectura.
En la documentacion se indica como un metodo apropiado para migrar a cloudnativepg.
Una vez finalizado el proceso, seran 2 clusteres independientes.
La autenticacion puede hacerse via usuario y contraseña o via certificado tls

# Enlaces con documentacion completa

- Bootstrap  
https://cloudnative-pg.io/documentation/1.22/bootstrap/

- Database import  
https://cloudnative-pg.io/documentation/1.22/database_import/

- Recovery  
https://cloudnative-pg.io/documentation/1.22/recovery/

- PGbasebackup  
https://cloudnative-pg.io/documentation/1.22/bootstrap/#bootstrap-from-a-live-cluster-pg_basebackup
https://cloudnative-pg.io/documentation/1.22/replica_cluster/