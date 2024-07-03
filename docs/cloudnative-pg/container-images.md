# Choosing the container images

It is possible to define the container images used in the cluster

## Operator image

The image of the operator (cloudnative-pg) can be overriden changing the image of the cnpg operator deployment

The releases can be found here:

<https://github.com/cloudnative-pg/cloudnative-pg/pkgs/container/cloudnative-pg>

## Operand images (postgresql)

This is the postgresql used in the cluster, and it can be overriden changing the "imageName" field of the cluster definition

> In cngp 1.23 there is a new and interesting ImageCatalog and ClusterImageCatalog crd to control the releases

The default release of postgresql offered by the the operator is the "latest available minor version of the latest stable major version supported by the PostgreSQL Community".

The best practice in production is to use an specific image, better with the SHA256 digest

There are community maintained postgresql operand images

- Project  
<https://github.com/cloudnative-pg/postgres-containers>  

- Registry  
<https://github.com/cloudnative-pg/postgres-containers/pkgs/container/postgresql>

Same for postgis

- Project  
<https://github.com/cloudnative-pg/postgis-containers>  

- Registry  
<https://github.com/cloudnative-pg/postgis-containers/pkgs/container/postgis>

> It is possible to build your own custom images  
See <https://cloudnative-pg.io/documentation/1.20/container_images/>

## Links

- Documentation  
<https://cloudnative-pg.io/docs/>
