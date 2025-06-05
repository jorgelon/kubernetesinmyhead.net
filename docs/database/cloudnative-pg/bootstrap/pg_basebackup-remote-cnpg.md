
# From remote cnpg

We can create a new cluster from an existing cnpg cluster.

## Requirements

In the source and destination cluster we need the same:

- the same major PostgreSQL release with imageName or imageCatalogRef
- the same hardware architecture
- the same tablespaces

We also need

- enough max_wal_senders
- network connectivity between them

## Importing the streaming_replica creds

We will use the streaming_replica role in the source cluster.

In order to get the credentials there, go to the namespace where the source cluster is located an export the secret that ends with "-replication"

```shell
kubectl get secret OMMITED-replication -o yaml
```

Then clean it and leave it this way

```yaml
apiVersion: v1
data:
  tls.crt: OMMITED
  tls.key: OMMITED
kind: Secret
metadata:
  name: OMMITED-replication
type: kubernetes.io/tls
```

Go to the namespace where the new cluster will be created and import the secret

```shell
kubectl apply -f mysecret.yaml
```

## The new cluster

Then create the new cluster with this basic settings

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cnpg
spec:
  imageCatalogRef: # or imageName
    apiGroup: postgresql.cnpg.io
    kind: ClusterImageCatalog
    major: 15 # must be the same major PostgreSQL
    name: postgresql
  externalClusters:
    - name: my-remote-cluster # descriptive name
      connectionParameters:
        host: my-remote-host # host or ip
        user: streaming_replica
        sslmode: require
      sslKey:
        name: OMMITED-replication
        key: tls.key
      sslCert:
        name: OMMITED-replication
        key: tls.crt
  bootstrap:
    pg_basebackup:
      source: my-remote-cluster
      # Next settings if we can create a database, owner and assign credentials to that user
      database: desired-db
      owner: db-owner-name
      secret:
        name: desired-db-secret
```

## Links

- Bootstrap from a live cluster (pg_basebackup)

<https://cloudnative-pg.io/documentation/1.26/bootstrap/#requirements>

- SSL Support

<https://www.postgresql.org/docs/current/libpq-ssl.html>
