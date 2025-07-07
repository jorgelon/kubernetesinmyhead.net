# Init

## Working with different environments and backend

If we share the code between different environments and backends, we need to run this:

```shell
terraform init -backend-config=path/to/backend-config.tfvars
```

- When switching between environments with different backends
- When changing backend settings (e.g., switching S3 buckets, Azure storage accounts, or vSphere datastores).
- When initializing a new environment with a different backend configuration.
- Whenever you want to reconfigure the backend (for example, after editing backend config files).

> You do not need to run -backend-config if only changing variables in your .tfvars files that are unrelated to the backend. Use it only for backend-specific changes.
