# Buildkit outputs

By default, the build result and intermediate cache will only remain internally in BuildKit. An output needs to be specified to retrieve the result.

> Multiple outputs are supported

## Image/Registry

pending

## Local directory

Buildkit permit to export the build result (files, directories, binaries or artifacts) directly to a directory on your local filesystem instead of the image itself.

For that, Buildkit copies the output files from the build context or build stages into a specified local directory on your machine.

This command will place the build output in the ./output directory on your local filesystem.

```txt
--output type=local,dest=./output
```

## Docker tarball

pending

## OCI tarball

pending

## containerd image store

pending
