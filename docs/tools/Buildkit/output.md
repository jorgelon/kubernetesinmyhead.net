# Buildkit outputs

By default, the build result and intermediate cache will only remain internally in BuildKit. An output needs to be specified to retrieve the result.

> Multiple outputs are supported

## Image/Registry

pending

### Authentication

If we want pass credentials to push the image to a repository, the DOCKER_CONFIG controls the directory where the credentials are defined via the config.json file.

> The default value of this variable is ~/.docker

## Local directory

Buildkit permit to export the build result (files, directories, binaries or artifacts) directly to a directory on your local filesystem instead of the image itself.

For that, Buildkit copies the output files from the build context or build stages into a specified local directory on your machine.

This command will place the build output in the ./output directory on your local filesystem.

```txt
--output type=local,dest=./output
```

## Docker tarball

We can also export it to a tarball.

```txt
--output type=tar,dest=out.tar
```

## OCI tarball

We can also export it to an OCI tarball

```txt
--output type=oci,dest=path/to/output.tar
```

## containerd image store

pending
