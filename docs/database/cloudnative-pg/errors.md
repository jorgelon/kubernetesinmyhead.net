# Errors

## WAL file not found in the recovery object store"

- See the logs in every cnpg instance
- Check the name of the failing .history file and see the .history files in the /var/lib/postgresql/wal/pg_wal/ directory of the instances
- Ensure you have the proper IRSA permissions
- Try to recreate all the instances with destroy | promote actions

## The token included in the request has no service account role association for it

```txt
ERROR: Barman cloud backup delete exception: Error when retrieving credentials from container-role: Error retrieving metadata: Received non 200 response 404 from container metadata:
...
(ResourceNotFoundException): The token included in the request has no service account role association for it., fault: client\n\n","error":"exit status 4"

```

This can be caused because there were some changes in the IRSA authentication (iam role, annotation,..)
To solve it, restart the cluster

## Error calling the HeadBucket operation

```txt
ERROR: Barman cloud WAL archiver exception: An error occurred (403) when calling the HeadBucket operation: Forbidden"
```

This is an AWS IAM permissions issue. Probably you need to add "s3:ListBucket" Action permissions to the bucket itself.

```json
{
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::BUCKETNAME"
        }
    ],
    "Version": "2012-10-17"
}
```

## "HTTP communication issue" error

Restart the controller

## A replica cannot be created

If we get errors like

```txt
"requested timeline XXX is not a child of this server's history"
"Latest checkpoint is at XXX on timeline XXX, but in the history of the requested timeline, the server forked off from that timeline at YYY."
```

and only the primary is up. We can:

- Do a manual backup via pgdump of every database
- Leave the cluster with only 1 replica and no backup section
- Rename the s3 folder or use a different serverName in the backup section.
- Enable the backup section and do a backup via the kubectl cnpg plugin
- If it works, increase the replicas to 3

## Using the csi driver NFS

- You can probably need to give more permissions
- spec.postgresUID and spec.postgresGID (default 26) in the cluster resource definition gives you more possibilities
- Don't use the subDir parameter

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: nfs-postgre
parameters:
  mountPermissions: "0777"
...
```

This avoids some permission errors and other like:

```txt
controller with name instance-cluster already exists. Controller names must be unique to avoid multiple controllers reporting to the same metric
```

```txt
stale NFS file handle
```

```txt
This is an old primary instance in a new cluster without backup
```
