# Alpine Linux Best Practices for Dockerfiles

Alpine Linux is a security-oriented, lightweight Linux distribution that has become the de facto standard for minimal container base images. This guide covers best practices for using Alpine's package manager (apk) in Dockerfiles.

## Key Principles

### 1. Always Use `--no-cache`

The most important flag when installing packages in Alpine.

```dockerfile
RUN apk add --no-cache curl git nginx
```

**Why:** The `--no-cache` flag prevents apk from storing the package index locally, reducing image size by approximately 1-3MB. This is essential for keeping container images lean.

**Without `--no-cache`:**

```dockerfile
# Bad - leaves cache files in the image
RUN apk add curl
# Results in ~2-3MB of unnecessary cache data
```

### 2. Combine Update and Install in a Single RUN Command

Always update the package index and install packages in the same `RUN` instruction.

```dockerfile
RUN apk update && apk add --no-cache package1 package2
```

**Why:** Each `RUN` instruction creates a new image layer. Combining operations prevents creating unnecessary layers with outdated package indexes.

**Anti-pattern:**

```dockerfile
# Bad - creates separate layers
RUN apk update
RUN apk add --no-cache curl
```

### 3. Use Virtual Packages for Build Dependencies

When you need build tools that aren't required in the final image, use virtual packages to group and remove them efficiently.

```dockerfile
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev && \
    pip install --no-cache-dir cryptography && \
    apk del .build-deps
```

**Why:** Virtual packages allow you to install and remove multiple packages as a single unit, ensuring build dependencies don't bloat your final image.

**Benefits:**

- Removes all build dependencies in one command
- Reduces final image size significantly (often 100-300MB savings)
- Keeps the image clean and minimal

### 4. Pin Package Versions for Reproducibility

Specify exact package versions to ensure consistent builds across time and environments.

```dockerfile
RUN apk add --no-cache \
    nginx=1.24.0-r15 \
    curl=8.5.0-r0 \
    ca-certificates=20240705-r0
```

**Why:** Without version pinning, your builds may pull different package versions over time, leading to inconsistent behavior or unexpected bugs.

**Finding versions:**

```bash
# Search for available versions
docker run --rm alpine:3.19 apk search -e nginx

# Check installed version
docker run --rm alpine:3.19 apk info nginx
```

### 5. Combine Related Operations in Single Layers

Group logically related commands together to minimize layers and improve build performance.

```dockerfile
RUN apk add --no-cache \
    python3 \
    py3-pip && \
    pip install --no-cache-dir -r requirements.txt && \
    adduser -D appuser && \
    chown -R appuser:appuser /app
```

**Why:** Fewer layers mean smaller images, faster builds, and better cache utilization.

### 6. Clean Up in the Same Layer

If not using `--no-cache`, ensure cleanup happens in the same `RUN` command.

```dockerfile
RUN apk update && \
    apk add package && \
    rm -rf /var/cache/apk/*
```

**Important:** However, using `--no-cache` is preferred as it's cleaner and more reliable.

## Advanced Patterns

### Multi-Stage Builds with Alpine

Use Alpine in build stages to keep final images minimal.

```dockerfile
# Build stage
FROM alpine:3.19 AS builder
RUN apk add --no-cache --virtual .build-deps \
    go \
    git \
    musl-dev && \
    go build -o /app main.go && \
    apk del .build-deps

# Final stage
FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

### Installing from Edge Repository

Sometimes you need newer packages from Alpine's edge repository.

```dockerfile
RUN apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
    package-name
```

**Caution:** Edge packages are less stable. Pin versions when using edge repositories.

### Adding Multiple Repositories

```dockerfile
RUN apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/main \
    --repository=http://dl-cdn.alpinelinux.org/alpine/v3.19/community \
    package1 package2
```

## Common Pitfalls to Avoid

### 1. Don't Run Update in a Separate Layer

```dockerfile
# Bad
RUN apk update
RUN apk add --no-cache curl

# Good
RUN apk update && apk add --no-cache curl
```

### 2. Don't Use `apk upgrade` in Production Images

```dockerfile
# Bad - unpredictable and breaks reproducibility
RUN apk upgrade

# Good - pin specific versions instead
RUN apk add --no-cache nginx=1.24.0-r15
```

**Why:** Using `apk upgrade` makes builds non-reproducible and can introduce breaking changes unexpectedly.

### 3. Don't Install Unnecessary Packages

```dockerfile
# Bad - bash adds ~10MB and increases attack surface
RUN apk add --no-cache bash curl wget git vim nano

# Good - minimal installation
RUN apk add --no-cache curl
```

**Common unnecessary packages:**

- `bash` (use Alpine's default `sh` when possible)
- `vim`, `nano` (not needed in production containers)
- `wget` (if you already have `curl`)

### 4. Don't Forget to Remove Build Dependencies

```dockerfile
# Bad - leaves 200MB+ of build tools
RUN apk add --no-cache gcc musl-dev && \
    pip install package

# Good - removes build tools
RUN apk add --no-cache --virtual .build-deps gcc musl-dev && \
    pip install package && \
    apk del .build-deps
```

## Package Equivalence Guide

When migrating from Debian/Ubuntu to Alpine, package names often differ:

| Debian/Ubuntu | Alpine | Notes |
|---------------|--------|-------|
| `build-essential` | `build-base` | Includes gcc, make, libc-dev |
| `python3-dev` | `python3-dev` | Same name |
| `libssl-dev` | `openssl-dev` | Different prefix |
| `libpq-dev` | `postgresql-dev` | Different name |
| `default-libmysqlclient-dev` | `mariadb-dev` | MySQL client |
| `libffi-dev` | `libffi-dev` | Same name |
| `libjpeg-dev` | `jpeg-dev` | Simplified name |
| `libpng-dev` | `libpng-dev` | Same name |

**Finding packages:**

```bash
# Search for packages
docker run --rm alpine:3.19 apk search keyword

# Get package info
docker run --rm alpine:3.19 apk info package-name
```

## Real-World Examples

### Python Application

```dockerfile
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ca-certificates

# Install build dependencies, build, then remove them
COPY requirements.txt .
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

COPY . /app
WORKDIR /app

CMD ["python3", "app.py"]
```

### Node.js Application

```dockerfile
FROM alpine:3.19

# Install Node.js and npm
RUN apk add --no-cache \
    nodejs=20.11.0-r0 \
    npm=10.2.5-r0

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production && \
    npm cache clean --force

COPY . .

USER node
CMD ["node", "server.js"]
```

### Go Application (Multi-stage)

```dockerfile
# Build stage
FROM alpine:3.19 AS builder
RUN apk add --no-cache go git
WORKDIR /build
COPY . .
RUN go build -ldflags="-w -s" -o app .

# Final stage
FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /build/app /usr/local/bin/app
USER nobody
ENTRYPOINT ["/usr/local/bin/app"]
```

## Security Considerations

### 1. Keep Base Image Updated

Regularly update your base image version:

```dockerfile
# Pin to specific version for reproducibility
FROM alpine:3.19

# Or use latest minor version (receives security updates)
FROM alpine:3
```

### 2. Run as Non-Root User

```dockerfile
RUN adduser -D -u 1000 appuser
USER appuser
```

### 3. Install Only Required Packages

Each package increases the attack surface. Audit your dependencies regularly.

### 4. Use Specific Package Versions

Pin versions to avoid supply chain attacks through malicious package updates.

## Performance Tips

### 1. Order Layers by Change Frequency

Put frequently changing instructions last to maximize cache hits:

```dockerfile
FROM alpine:3.19

# Rarely changes - cached
RUN apk add --no-cache python3 py3-pip

# Changes occasionally - cached if requirements unchanged
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Changes frequently - rebuilt often
COPY . /app
```

### 2. Use BuildKit for Better Caching

```bash
DOCKER_BUILDKIT=1 docker build -t myapp .
```

### 3. Leverage Multi-Stage Builds

Keep build tools in separate stages to minimize final image size.

## Useful apk Commands

```bash
# Update package index
apk update

# Install package
apk add package-name

# Install without caching
apk add --no-cache package-name

# Install specific version
apk add package-name=1.2.3-r0

# Search for packages
apk search keyword

# Show package info
apk info package-name

# List installed packages
apk list --installed

# Remove package
apk del package-name

# Remove virtual package group
apk del .build-deps
```

## Links and Resources

- [Alpine Linux Official Website](https://alpinelinux.org/)
- [Alpine Linux Docker Hub](https://hub.docker.com/_/alpine)
- [Alpine Linux Packages](https://pkgs.alpinelinux.org/packages)
- [Alpine Linux Wiki](https://wiki.alpinelinux.org/)
- [apk-tools Documentation](https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper)

## When Not to Use Alpine

While Alpine is excellent for most use cases, consider alternatives when:

1. **Binary compatibility issues** - Your application requires glibc (Alpine uses musl libc)
2. **Performance critical** - Some applications show performance degradation with musl (2x slowdowns reported in edge cases)
3. **Limited package availability** - The package you need isn't available in Alpine repositories
4. **Team familiarity** - Your team is more comfortable with Debian/Ubuntu ecosystems

In these cases, consider Debian Slim, Ubuntu, or distroless images instead.
