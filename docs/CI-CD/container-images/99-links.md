# Links

- [Github event types](https://docs.github.com/en/rest/using-the-rest-api/github-event-types)
  - The GitHub reference of the events in the REST API, with the payload of each event.
- [Gitlab Webhook events](https://docs.gitlab.com/user/project/integrations/webhook_events/)
  - The GitLab reference of the webhook events, for example push, tag, and merge request events, with their payloads.
- [To be continuous - Gitlab](https://to-be-continuous.gitlab.io/doc/ref/docker/)
  - A set of GitLab CI templates. The Docker template builds, tests, and publishes container images.
- [Docker metadata action](https://github.com/docker/metadata-action)
  - A GitHub action that calculates the image tags and OCI labels from the git event.
- [Docker Build push action](https://github.com/docker/build-push-action)
  - A GitHub action that builds an image with Buildx and pushes it to a registry.

## Tools

- [Crane-Krane-Gcrane](https://github.com/google/go-containerregistry)
  - A Go library and CLI tools that work with images in a registry without a Docker daemon.
  - `crane` copies, tags, and reads digests. `krane` adds Kubernetes credential helpers. `gcrane` adds Google Cloud features.
- [Skopeo](https://github.com/podman-container-tools/skopeo)
  - A CLI tool that inspects, copies, and deletes images in registries without a Docker daemon.
- [Oras](https://github.com/oras-project/oras)
  - A CLI tool that pushes and pulls OCI artifacts, for example Helm charts, SBOMs, or signatures, to a registry.
