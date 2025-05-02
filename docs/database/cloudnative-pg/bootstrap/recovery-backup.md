# Recovery from a backup

## Recreate the cluster from a backup object

If we have a backup section and working backups in our cluster, the easiest way recreate a failing cnpg cluster is using a backup object.

- Choose the desired backup

To see our backups in our namespace

```shell
kubectl get backup
```

- Delete the cluster
  
Then delete the cluster

```shell
kubectl delete cluster MYCLUSTER
```

- Change the cluster definition

Configure the desired backup name changing the bootstrap section

```yaml
spec:
  bootstrap:
    recovery:
      backup:
        name: MYWORKINGBACKUP
```

- Change where the new backups will be stored

Change the destination of the new backups. The recovery from backup fails is cnpg find a non empty folder. I think it is a good practice to start this new cluster storing the data in a new empty folder.

```yaml
spec:
  backup:
    barmanObjectStore:
      serverName: ANOTHERFOLDER
```

- Apply the new cluster

Finally apply the new cluster definition
