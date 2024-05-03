# Formas de hacer backup

Existen 2 forma de hacer backups de postgresql:

- fisicas, a nivel de sistema de ficheros
- logicas, usando pg_dump

Cloudnative-pg se centra en los backups fisicos aunque nos ofrece informacion sobre como usar pg_dump

https://cloudnative-pg.io/documentation/1.22/troubleshooting/#emergency-backup

# Recursos de los que se hacen backup

Cloudnative-pg hace backup de 2 recursos: el wal archive y el backup fisico

## WAL archiving

Los registros trasaccionales, que necesitan del backup fisico para ser utiles, solo soportan de momento el backup en object stores y permiten:

- Hot/Online backups  
Hacer backup en caliente de una replica primaria o secundaria

- Point in Time recovery (PITR)  
Restaurar a un punto concreto a elegir desde el primer backup disponible. 

> Con Wal archiving funcionando, cloudnative-pg provee un RPO (recovery point objective), algo asi como el mayor tiempo de perdida de datos, inferior a 5 minutos

> Cloudnative-pg recomienda usar siempre en produccion wal archiving. En algunos entornos, sobre todo de desarrollo, puede no ser necesario el wal archiving o incluso cualquier backup

# Backup fisico
El backup fisico de los datos en si se refiere al PGDATA y cualquier tablespace

Se puede hacer en object stores y, desde la version 1.21, en kubernetes volumesnapshots

## Diferencias de hacer backup en object store o volume snapshot

|                               | Object store  | Volume Snapshot               |
|-------------------------------|---------------|-------------------------------|
| Hot                           | Wal requerido | Wal recomendado en produccion |
| Cold                          | No            | Si                            |
| Incremental                   | No            | Segun la storageclass         |
| Differential                  | No            | Segun la storageclass         |
| Retention policy              | Si            | No                            |
| Backup desde standby          | Si            | Si                            |
| Snapshot recovery             | Emulado       | Si                            |
| Point In Time Recovery (PITR) | Si            | Wal requerido                 |
| Tecnologia usada              | Barman cloud  | Kubernetes API                |

Elegir entre backup basado en object store o volume snapshot dependera de cuestiones como el object store disponible, lo que soporte la storageclass o el tamaño de la bbdd

# Configurar el backup en la especificacion del recurso cluster

En spec.backup se indica

- la configuracion para volumeSnapshot, incluyendo:
  -  spec.backup.volumeSnapshot.onlineConfiguration
  -  spec.backup.volumeSnapshot.snapshotOwnerReference (relevante para el comportamiento tras el borrado de backup)
- la configuracion para barmanObjectStore y su retention policy
- el target  
Este valor indica si el backup se hara sobre la replica primaria o si se hara preferiblemente sobre la replica en standby mas actualizada (valor por defecto). Esta configuracion ademas la heredaran los objetos de tipo Backup y ScheduledBackup que no hayan especificado el target

https://cloudnative-pg.io/documentation/1.22/cloudnative-pg.v1/#postgresql-cnpg-io-v1-BackupConfiguration

## Creando backups y backups programados

Se pueden crear objectos de tipo Backup y ScheduledBackup
En ambos casos se define:
- el cluster al que hacer backup 
- el target antes comentado, si queremos algo diferente a spec.backup.target
- si sera online/hot (por defecto) u offline/cold
- si queremos onlineConfiguration diferente a lo definido en spec.backup.volumeSnapshot.onlineConfiguration del cluster

- Backup  
Es un backup puntual, y se puede elegir:
  - si sera volumeSnapshot o barmanObjectStore

- ScheduledBackup
Es un backup programado, y se puede elegir:
    - si el backup esta suspendido
    - si queremos un backup nada mas crear el ScheduledBackup
    - su programacion
    - el ownerReference del backup

# Enlaces

- Backup  
https://cloudnative-pg.io/documentation/1.22/backup/

- Wal archiving  
https://cloudnative-pg.io/documentation/1.22/wal_archiving/

- Backup en object stores  
https://cloudnative-pg.io/documentation/1.22/backup_barmanobjectstore/
https://cloudnative-pg.io/documentation/1.22/appendixes/object_stores/

- Backup en volume snapshots  
https://cloudnative-pg.io/documentation/1.22/backup_volumesnapshot/