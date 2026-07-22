# PostgreSQL operand Images

There are 2 ways to define the postgresql (operand) image we want to use in a CloudNative-PG cluster:

- using directly the container image under **spec.imageName**

- using an existing ImageCatalog or ClusterImageCatalog under **spec.imageCatalogRef**

## Official CNPG images

CloudNative-PG builds and provides some postgresql container images and ClusterImageCatalog ready to be used in their clusters.
Both have changed in the latest years, but the recommended way to use them is this.

### Minimal images

If you do not expect to use additional extensions the best option is the **minimal images**. These images include APT debian PostgreSQL packages from PostgreSQL Global Development Group (PGDG).

The related ClusterImageCatalog for debian stable (trixie) is located here:

<https://github.com/cloudnative-pg/artifacts/blob/main/image-catalogs/catalog-minimal-trixie.yaml>

### Minimal images + extensions

Starting with **postgresql 18 + CNPG operator 1.29 + Kubernetes 1.35** you can **dynamically add extensions to a CNPG cluster**. CNPG team is building some extensions ready to be added that way.

The related ClusterImageCatalog for debian stable (trixie) is located here:

<https://github.com/cloudnative-pg/artifacts/blob/main/image-catalogs-extensions/catalog-minimal-trixie.yaml>

### Standard images

CNPG team also provides standard images. They are minimal images with some additional features like pgaudit, Postgres Failover Slots, pgvector and all locales

The related ClusterImageCatalog for debian stable (trixie) is located here:

<https://github.com/cloudnative-pg/artifacts/blob/main/image-catalogs/catalog-standard-trixie.yaml>

### Postgis

CloudNative-PG also builds and provides some postgis container images based on standard images. The standard ClusterImageCatalog for debian stable (trixie) is located here:

<https://github.com/cloudnative-pg/postgis-containers/blob/main/image-catalogs/postgis-standard-trixie.yaml>

The plan is to stop offering this postgis container images once PostgreSQL 17 reaches end of life (November 2029). The reason is a combination of features like the extension_control_path (postgresql 18), image volume extensions (CNPG 1.29) and ImageVolume (kubernetes 1.35). This will remove the need for dedicated PostGIS container images"

Then, if we want to use postgis using official images and catalogs we have 2 options

- If running postgresql 18 + CNPG >=1.29 + kubernetes >=1.35 we can add postgis using the minimal image + extension ClusterImageCatalog
- If not, you can use current dedicated postgis containers but with that November 2029 as limit

### Custom image

It is possible to build [your own custom images](https://cloudnative-pg.io/docs/current/container_images/)

## Not recommended resources

- system images

The system images are based on standard images and they include Barman Cloud binaries for backup operations. This method is being replaced by the barman cloud plugin method. They will be removed when in-core Barman Cloud support is phased out

- legacy catalogs and images

Some legacy catalogs here <https://github.com/cloudnative-pg/postgres-containers/tree/main/Debian>

## Operator image

We can also override the container image of the operator (cloudnative-pg) changing the image of the cnpg operator deployment

The releases can be found here:

<https://github.com/cloudnative-pg/cloudnative-pg/pkgs/container/cloudnative-pg>

> the value of the OPERATOR_IMAGE_NAME will be applied in the sidecar of every instance of the cluster

## Links

- CNPG postgre images github repo

<https://github.com/cloudnative-pg/postgres-containers>

- CNPG postgre images registry:

<https://github.com/cloudnative-pg/postgres-containers/pkgs/container/postgresql>

- CNPG postgis images github repo

<https://github.com/cloudnative-pg/postgis-containers>

- CNPG postgis images registry:

<https://github.com/cloudnative-pg/postgis-containers/pkgs/container/postgis>

- Postgresql extension_control_path

<https://postgresqlco.nf/doc/en/param/extension_control_path/>

- Image Volume Extensions

<https://cloudnative-pg.io/docs/current/imagevolume_extensions>

- Use an Image Volume With a Pod

<https://kubernetes.io/docs/tasks/configure-pod-container/image-volumes/>
