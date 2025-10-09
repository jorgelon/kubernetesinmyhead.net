# Distroless images

Distroless images are minimal container images that contain only the application and its runtime dependencies, without including package managers, shells, or other standard Linux distribution utilities.

## Key Benefits

- **Reduced Attack Surface**: No shell or package manager means fewer vulnerabilities to exploit
- **Smaller Image Size**: Only essential runtime components are included
- **Improved Security**: Minimizes the potential for supply chain attacks
- **Better Compliance**: Easier to audit and maintain due to fewer components

## Common Use Cases

- Production deployments where security is critical
- Microservices and cloud-native applications
- Containerized applications that don't require debugging tools in production

## Popular Distroless and Minimal Base Images

### Google Distroless

Primarily maintained by Google and available at `gcr.io/distroless/`.

**Key Features:**

- No shell or package manager
- Supports multiple runtimes: static binaries, Java, Python, Node.js, .NET
- Based on Debian

**Size:** ~110MB for multi-stage builds with distroless (vs 848MB without optimization)

**Links:**

- [GitHub Repository](https://github.com/GoogleContainerTools/distroless)

### Chainguard Images (Wolfi-based)

Built on Wolfi, a Linux distribution designed for cloud workloads with zero known CVEs.

**Key Features:**

- Uses glibc (not musl like Alpine)
- Constantly rebuilt with latest sources
- Includes SBOMs for every image
- No kernel (container runtime only)
- Uses apk package manager

**Available at:** `cgr.dev/chainguard/`

**Links:**

- [Chainguard Images GitHub](https://github.com/chainguard-images)
- [Wolfi GitHub](https://github.com/wolfi-dev)
- [Official Website](https://www.chainguard.dev/)
- [Image Directory](https://images.chainguard.dev/)
- [Documentation](https://edu.chainguard.dev/)

### Alpine Linux

Popular minimal Linux distribution (~5MB base image).

**Key Features:**

- Uses musl libc (not glibc)
- BusyBox tool suite
- apk package manager included
- Very small size

**Considerations:**

- Some applications require glibc and won't work with musl
- Performance degradation possible (2x slowdown not uncommon)
- Limited package availability compared to Debian/Ubuntu

**Links:**

- [Official Website](https://alpinelinux.org/)
- [Docker Hub](https://hub.docker.com/_/alpine)

### Ubuntu Chiseled

Distroless images built from Ubuntu packages using Chisel.

**Key Features:**

- Uses glibc
- No shell or package manager in final image
- Only minimal required dependencies included
- Carefully sliced packages

**Available at:** `ubuntu/` on Docker Hub

**Links:**

- [Official Page](https://ubuntu.com/containers/chiseled)
- [Chisel Documentation](https://documentation.ubuntu.com/chisel/)
- [Docker Hub](https://hub.docker.com/r/ubuntu/chiselled-jre)

### Debian Slim

Pared-down Debian with commonly needed tools removed.

**Key Features:**

- Uses glibc
- apt package manager included
- Good balance between size and functionality
- ~74MB (vs 118MB for full Debian)

**Links:**

- [Official Website](https://www.debian.org/)
- [Docker Hub](https://hub.docker.com/_/debian)

### Red Hat UBI Minimal

RHEL-based minimal image for enterprise environments.

**Key Features:**

- Based on RHEL packages
- microdnf package manager (scaled-down DNF)
- Strong security focus and timely updates
- ~92MB on disk, 32MB compressed

**Considerations:**

- Limited to curated Red Hat packages
- Best for Red Hat ecosystem (OpenShift, RHEL)
- Subscription required for non-UBI packages

**Links:**

- [Red Hat Catalog](https://catalog.redhat.com/software/base-images)
- [UBI FAQ](https://developers.redhat.com/articles/ubi-faq)
- [Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/)

### Bitnami Minideb

Debian-based image built with debootstrap.

**Key Features:**

- Uses glibc
- apt package manager included
- `install_packages` helper command
- ~50MB base size
- Base for many Bitnami application images

**Links:**

- [GitHub Repository](https://github.com/bitnami/minideb)
- [Docker Hub](https://hub.docker.com/r/bitnami/minideb)

### BusyBox

Single compact executable with simplified Linux tools.

**Key Features:**

- Multiple libc flavors: musl, glibc, uclibc
- Includes basic utilities (file archiving, process manipulation, etc.)
- Extremely minimal

**Links:**

- [Official Website](https://busybox.net/)
- [Docker Hub](https://hub.docker.com/_/busybox)

### Scratch

Docker's most minimal base - literally empty.

**Key Features:**

- Contains nothing at all
- Only suitable for static binaries
- Smallest possible image

**Links:**

- [Docker Documentation](https://hub.docker.com/_/scratch)

## Comparison Summary

| Image           | Maintainer        | Size       | Package Manager  | libc    | Use Case                       |
|-----------------|-------------------|------------|------------------|---------|--------------------------------|
| Scratch         | Docker            | 0 MB       | None             | None    | Static binaries only           |
| Alpine          | Alpine Linux      | ~5 MB      | apk              | musl    | General purpose, size-critical |
| Distroless      | Google            | ~25-100 MB | None             | glibc   | Production, high security      |
| BusyBox         | BusyBox Project   | ~5 MB      | None             | Various | Basic utilities needed         |
| Chainguard      | Chainguard        | ~20-80 MB  | apk (build only) | glibc   | Supply chain security          |
| Ubuntu Chiseled | Canonical         | ~20-50 MB  | None             | glibc   | Ubuntu ecosystem               |
| Minideb         | Bitnami (VMware)  | ~50 MB     | apt              | glibc   | Balance of size and packages   |
| Debian Slim     | Debian Project    | ~74 MB     | apt              | glibc   | More tooling, Debian packages  |
| UBI Minimal     | Red Hat           | ~92 MB     | microdnf         | glibc   | Enterprise/Red Hat ecosystem   |

## Multi-Stage Build Pattern

Distroless images are typically used in multi-stage builds where dependencies are installed in a full-featured image, then only the application and runtime are copied to the distroless final image:

```dockerfile
# Build stage
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Final stage
FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/myapp /myapp
ENTRYPOINT ["/myapp"]
```

## Important Note on ENTRYPOINT

Distroless images without a shell require ENTRYPOINT to be specified in exec form (JSON array), not shell form:

```dockerfile
# Correct - exec form
ENTRYPOINT ["/myapp", "--flag"]

# Wrong - shell form (requires /bin/sh)
ENTRYPOINT /myapp --flag
```
