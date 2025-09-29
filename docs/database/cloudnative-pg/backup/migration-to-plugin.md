# Migration to barman cloud plugin

## Install the barman cloud plugin

Follow <https://cloudnative-pg.io/plugin-barman-cloud/docs/installation/>

Requirements

- CloudNativePG version 1.26 or later. 1.27 has some improvements
- cert-manager

## Create an ObjectStore

We must translate the spec.backup.barmanObjectStore section of the cluster to a new ObjectStore resource, under spec.configuration.

> serverName must be empty here. It must be configured in the the plugins section in the cluster

## Migration

Here we must do some changes at once

- Remove the **spec.backup.barmanObjectStore** section and **spec.backup.retentionPolicy** if it was defined. Also remove the **entire spec.backup** section if it is now empty

- Configure the spec.plugin section

parameters: barmanObjectName and serverName if needed

- Add barman-cloud.cloudnative-pg.io to the plugins list, as described in Configuring WAL archiving

> This change restarts the cluster pods

## Migration test

- Check the wal backup is working

- Create a manual backup

```shell
kubectl cnpg backup MYCLUSTER --method=plugin --plugin-name=barman-cloud.cloudnative-pg.io
```

## Update the scheduled backup

If it works, update the scheduled backup to use the plugin

changing

```yaml
    method: barmanObjectStore
```

for

```yaml
    method: plugin
        pluginConfiguration:
        name: barman-cloud.cloudnative-pg.io
```

## Change the images

Finally don't use legacy or system images and migrate to minimal or standard images

[See here for more info](../postgre-images.md)

## Links

- Migrating from Built-in CloudNativePG Backup

<https://cloudnative-pg.io/plugin-barman-cloud/docs/migration/>

- [Bug]: Missing prometheus metrics

After migrating to the barman cloud plugin, some Prometheus metrics related to backup monitoring may not be available or properly exposed. This affects monitoring dashboards that rely on backup-specific metrics to track backup success/failure rates and timing.

<https://github.com/cloudnative-pg/cloudnative-pg/issues/7812>
