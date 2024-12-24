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
