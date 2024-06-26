# Crear un cluster partiendo de un backup via barmanObjectStore en s3

Para crear un cluster partiendo de un backup via barmanObjectStore en s3 hay que tener en cuenta varias cuestiones

## Definir el bootstrap

En el spec del cluster hay que indicar que el bootstrap sera recovery y que usara como origen un externalCluster

### Notas adicionales

- Es interesante definir el nombre de la bbdd y el owner que tendra, alineado con la bbdd que estamos importando. Esto creara un secret con las nuevas credenciales del usuario de la bbdd. Tambien podemos indicarselas mediante un secret

- El operador mantiene el nombre de las bbdd y usuarios de origen se mantienen pero no se trae los posibles secrets de origen

- Para mantener el superusuario de origen se debe usar enableSuperuserAccess y superuserSecret

- Adicionalmente Podemos elegir el PITR mediante recoveryTarget, sino por defecto se buscara el ultimo wal disponible

- barmanObjectStore.wal.maxParallel permite definir el numero de archivos WAL en paralelo para ser restaurados. Por defecto es de uno en uno

```yaml
spec:
  [...]
  bootstrap:
    recovery:
        source: miclusterdeorigen # nombre del external cluster
        database: bbdd # por defecto sera app. si no existe la bbdd la crea
        owner: owner # por defecto sera app. si no existe el usuario lo crea y si no es owner, lo convierte en owner
        secret: # si queremos especificar credenciales. 
            name: owner-creds # debe contener username: elowner y password: elpassworddeseado
```

## Definir el externalCluster

Algunas de las opciones mas importantes a la hora de definirlo

- name:  
Es el nombre descriptivo del cluster

- destinationPath:  
hay que poner s3:// seguido del path hasta el directorio donde se ve la carpeta donde esta nuestro backup
por ejemplo, si la carpeta del backup es  s3://mibucket/micluster/, se debe poner s3://mibucket/

- serverName:  
Cloudnativepg por defecto buscara una carpeta dentro del destinationPath con el nombre del external cluster. Si difiere, se puede usar serverName para indicar el nombre de la carpeta

- s3Credentials:  
Hay 2 formas de definir las credenciales:
  - Usando un secret que contenga el accessKey, secretAccessKey y region
  - Usando IRSA

Por ejemplo, usando el secret seria:  

```yaml
[...]
spec:
  externalClusters:
    - name: nombredelexternalcluster
      barmanObjectStore:
        serverName: nombredelclusterorigen
        destinationPath: s3://path/
        s3Credentials:
          accessKeyId:
            name: aws-s3
            key: ACCESS_KEY_ID
          secretAccessKey:
            name: aws-s3
            key: ACCESS_SECRET_KEY
          region:
            name: aws-s3
            key: AWS_REGION
[...]
```

Usando IRSA seria:  

```yaml
[...]
spec:
  serviceAccountTemplate:
    metadata:
      annotations:
        eks.amazonaws.com/role-arn: "el arn del rol"
  externalClusters:
    - name: nombredelexternalcluster
      barmanObjectStore:
        serverName: nombredelclusterorigen
        destinationPath: s3://path/
        s3Credentials:
          inheritFromIAMRole: true
```

## Links

- Recovery  
<https://cloudnative-pg.io/documentation/1.22/recovery/>

- Recovery spec  
<https://cloudnative-pg.io/documentation/1.22/cloudnative-pg.v1/#postgresql-cnpg-io-v1-BootstrapRecovery>

- Configure the application database  
<https://cloudnative-pg.io/documentation/1.22/bootstrap/#configure-the-application-database>

- External Cluster spec  
<https://cloudnative-pg.io/documentation/1.22/cloudnative-pg.v1/#postgresql-cnpg-io-v1-ExternalCluster>
