# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a MkDocs-based documentation site (`kubernetesinmyhead.net`) containing personal notes and guides about Kubernetes and cloud-native technologies. The site is built using MkDocs with the Material theme and deployed via GitHub Pages.

## Architecture & Structure

### Documentation Organization

- **Core directories structure**:
  - `docs/` - All documentation content organized by technology/domain
  - `mkdocs.yml` - MkDocs configuration with Material theme
  - `.github/workflows/` - CI/CD pipelines for security scanning

### Content Categories

- `CI-CD/` - Argo Workflows, Argo Events, GitLab CI/CD, Renovate
- `database/` - CloudNative-PG, PostgreSQL guides
- `deployment/` - Deployment tools, like cluster api or argo rollouts
- `gitops/` - ArgoCD, FluxCD, Kargo configurations and guides  
- `kubernetes/` - Core K8s concepts, security, networking, storage
- `languages/` - Some notes about languages
- `misc/` - Miscelanea
- `networking/` - Cilium, Contour, MetalLB, network policies
- `observability/` - Prometheus, Grafana, metrics, monitoring
- `platforms/` - AWS, Azure, cloud-specific configurations
- `queues/` - Nats, Kafka,...
- `security/` - External Secrets, Keycloak, certificate management
- `services/` - Typical k8s services like external dns or vmware harbor
- `storage/` - Storage related things
- `tools/` - Git, Helm, Kustomize, Terraform guides
- `vibe-sreing/` - Ai related things

### File Naming Conventions

- `98-tips.md` - Tips and best practices for the topic
- `99-links.md` - Reference links and external resources

### Git Workflow

- Repository uses multiple security scanners via pre-commit hooks
- GitHub Actions run Gitleaks on all pushes and PRs
- Talisman and TruffleHog configured for local pre-commit scanning

## Development Guidelines

### Content Creation

- Follow existing directory structure when adding new topics
- Use consistent file naming (98-tips.md, 99-links.md pattern)
- Include practical examples and YAML manifests where applicable
- Focus on defensive security practices and configurations

### Security First

- All content focuses on defensive security implementations
- Never include actual secrets, tokens, or sensitive configuration
- Use placeholder values in examples (e.g., `<your-secret-here>`)
- Multiple layers of secret scanning are in place

### Technical Focus Areas

- Kubernetes-native solutions and cloud-native patterns
- Infrastructure as Code and GitOps methodologies  
- Observability and monitoring best practices
- Security hardening and compliance configurations
- Multi-cloud and hybrid cloud architectures

## Key Technologies Covered

- **Container Orchestration**: Kubernetes, container runtimes
- **GitOps**: ArgoCD, FluxCD, Kargo for declarative deployments
- **CI/CD**: Argo Workflows, GitLab CI/CD, GitHub Actions
- **Observability**: Prometheus, Grafana, OpenTelemetry, Loki
- **Security**: External Secrets, Keycloak, OAuth2 Proxy, Kyverno
- **Networking**: Cilium, Ingress controllers, service mesh concepts
- **Storage**: CloudNative-PG, persistent volumes, backup strategies
- **Cloud Platforms**: AWS EKS, Azure AKS, platform-specific guides
