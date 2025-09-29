# PostgreSQL operand Images

There are 2 ways to define the postgresql (operand) image we want to use in a CloudNative-PG cluster:

- using spec.imageName

Here we configure the url of the docker image

- using spec.imageCatalogRef

Here we can select a version from an existing ImageCatalog or ClusterImageCatalog

## Oficial postgresql images

CloudNative-PG builds and provides some postgresql images ready to be used

### Postgresql images

- Github repo

<https://github.com/cloudnative-pg/postgres-containers>

- Registry

<https://github.com/cloudnative-pg/postgres-containers/pkgs/container/postgresql>

Here we can find 3 image types:

- Minimal

They include APT PostgreSQL packages from PostgreSQL Global Development Group (PGDG).

- standard

They include pgaudit, Postgres Failover Slots, pgvector, all locales and LLVM JIT support until 18 release

- system (Deprecated)

They are based on standard images. Include Barman Cloud binaries for backup operations and they will be removed when in-core Barman Cloud support is phased out

#### Postgresql ClusterImageCatalogs

All the current provided ClusterImageCatalogs located are here:

<https://github.com/cloudnative-pg/artifacts/tree/main/image-catalogs>

They include the standard, minimal and system images

Also there are some legacy catalogs here:

<https://github.com/cloudnative-pg/postgres-containers/tree/main/Debian>

### Postgis images

CloudNative-PG also builds and provides some postgis images. But the plan is to stop offering postgis image once PostgreSQL 17 reaches end of life (November 2029).

> "Starting with PostgreSQL 18, the extension_control_path GUC will allow PostGIS to be mounted as a separate image volume, removing the need for dedicated PostGIS container images."

- Github repo

<https://github.com/cloudnative-pg/postgis-containers>

- Registry

<https://github.com/cloudnative-pg/postgis-containers/pkgs/container/postgis>

Here we can find 2 image types:

- standard

Without Barman Cloud

- system (Deprecated)

with Barman Cloud

#### Postgis ClusterImageCatalogs

All the current provided ClusterImageCatalogs located are here:

They include the standard and system images

<https://github.com/cloudnative-pg/postgis-containers/tree/main/image-catalogs>

## Important notes

### Migration Path

- Move to the the backup barman plugin
- Avoid using system images. Move to standard or minimal.
- Avoid using system or legacy ClusterImageCatalogs. Move to standard or minimal.

### Default release

The default release of postgresql offered bye the the operator is the "latest available minor version of the latest stable major version supported by the PostgreSQL Community". The best practice in production is to use an specific image, better with the SHA256 digest

### Custom image

It is possible to build [your own custom images](https://cloudnative-pg.io/documentation/current/container_images/)

### Operator image

We can also override the container image of the operator (cloudnative-pg) changing the image of the cnpg operator deployment

The releases can be found here:

<https://github.com/cloudnative-pg/cloudnative-pg/pkgs/container/cloudnative-pg>

> the value of the OPERATOR_IMAGE_NAME will be applied in the sidecar of every instance of the cluster
