# Cloud secret storages and backup

Both have secrets versioning

## Azure key vault

- Permits manual backups

<https://learn.microsoft.com/en-us/azure/key-vault/general/backup>

- You can enable purge protection at key vault level

<https://learn.microsoft.com/en-gb/azure/key-vault/general/soft-delete-overview>

## AWS secrets manager

- Permits manual backups  
<https://docs.aws.amazon.com/cli/latest/reference/secretsmanager/>

- If you delete a secret, it is maintained 7 days at least  
<https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_delete-secret.html>

- You can add a replicacion between regions  
<https://aws.amazon.com/blogs/security/how-to-replicate-secrets-aws-secrets-manager-multiple-regions/>
