# Build container images

## docker build

What: The classic Docker CLI command to build images.
Engine: Uses the legacy Docker image builder by default, but can use BuildKit if enabled.
Features: Basic Dockerfile support, single-platform builds, limited caching.

```shell
docker build -t myimage .
```

<https://docs.gitlab.com/ci/docker/using_docker_build/>

## docker buildx

What: An advanced Docker CLI plugin for building images.
Engine: Uses BuildKit under the hood.
Features:
Multi-platform builds (e.g., build for amd64 and arm64 in one command)
Advanced caching (local, registry, inline)
Output to multiple formats (Docker, OCI, tar, etc.)
Build secrets, better performance

```shell
docker buildx build --platform linux/amd64,linux/arm64 -t myimage .
```

## buildkit

What: The next-generation image builder for Docker, designed for speed and flexibility.
Engine: Can be used standalone or as the backend for docker build and docker buildx.
Features:
Parallel build steps
Advanced caching
Build secrets
Improved performance
Usage:
Enabled in Docker with DOCKER_BUILDKIT=1 docker build ...
Used natively by docker buildx

```shell
DOCKER_BUILDKIT=1 docker build .
```

<https://docs.gitlab.com/ci/docker/using_buildkit/>

## buildah

What: A Red Hat-sponsored, daemonless tool for building OCI and Docker images.
Engine: Standalone, does not require the Docker daemon.
Features:
Scriptable, fine-grained control over image layers
Rootless builds
Integrates well with Podman and OpenShift
No need for a running Docker daemon

```shell
buildah bud -t myimage .
```

<https://docs.gitlab.com/ci/docker/buildah_rootless_multi_arch/>

## podman

## kaniko

The project has no mantainers
