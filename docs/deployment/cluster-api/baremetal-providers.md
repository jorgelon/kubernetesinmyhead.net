# Bare Metal Infrastructure Providers

Cluster API provides several infrastructure providers designed specifically for bare metal environments or that support bare metal deployments. This document explores the available options and their characteristics.

## Overview

Bare metal infrastructure providers enable Kubernetes cluster provisioning on physical servers without requiring a virtualization layer or cloud provider. These providers handle hardware lifecycle management, OS provisioning, and Kubernetes node bootstrapping.

## Dedicated Bare Metal Providers

### Metal3

The most mature and widely adopted bare metal provider for Cluster API.

**Key Features:**

- Uses OpenStack Ironic for bare metal provisioning
- Supports hardware introspection and discovery
- Handles firmware and BIOS configuration
- Provides power management capabilities (IPMI, Redfish)
- Network boot support (PXE, iPXE)

**Architecture:**

- Leverages BareMetalHost custom resources
- Integrates with Metal3-io ecosystem
- Supports multiple boot methods

**Use Cases:**

- On-premises data centers
- Edge computing deployments
- Environments requiring hardware-level control

**Get started:**

```shell
clusterctl init --infrastructure metal3
```

**Links:**

- <https://github.com/metal3-io/cluster-api-provider-metal3>
- <https://metal3.io/>

### Tinkerbell

A bare metal provisioning framework designed for scalability and flexibility.

**Key Features:**

- Workflow-based provisioning system
- Microservices architecture
- Hardware data management
- DHCP and TFTP services included
- Custom workflow definitions

**Architecture:**

- Workflow engine (temporal-based)
- Hardware database (Hegel)
- Network boot services (Boots)
- Image serving (Registry)

**Use Cases:**

- Modern cloud-native bare metal environments
- Organizations needing customizable provisioning workflows
- Multi-tenant bare metal platforms

**Get started:**

```shell
clusterctl init --infrastructure tinkerbell
```

**Links:**

- <https://github.com/tinkerbell/cluster-api-provider-tinkerbell>
- <https://tinkerbell.org/>

### Sidero (Community Maintained)

> **Note:** Sidero Labs is no longer actively developing Sidero Metal. The project is now community-maintained. For new deployments, Sidero Labs recommends using **Omni** as the alternative.

A bare metal provider built specifically for Talos Linux.

**Key Features:**

- Talos Linux native integration
- API-driven bare metal management
- Automatic hardware discovery
- Secure boot support
- Immutable infrastructure approach

**Architecture:**

- Sidero Metal platform
- Integration with Talos Control Plane provider
- IPMI/Redfish for power management

**Status:**

- No longer actively developed by Sidero Labs
- Community-maintained (Slack support available)
- Supports Kubernetes v1.34 and Talos v1.11
- Recommended to use Omni for new deployments

**Links:**

- <https://github.com/siderolabs/sidero>
- <https://www.sidero.dev/>

### Omni (Sidero Labs Alternative)

The successor to Sidero from Sidero Labs, providing a SaaS platform for Talos Linux cluster management.

**Key Features:**

- Managed Talos Linux platform
- Multi-cluster management
- Works with bare metal, cloud, and edge
- Web-based UI and API
- Secure by default (WireGuard-based)
- GitOps integration

**Architecture:**

- SaaS control plane (self-hosted option available)
- Lightweight agents on managed nodes
- No PXE boot infrastructure requirements
- Works with existing bare metal

**Use Cases:**

- Organizations using Talos Linux
- Multi-environment deployments (bare metal + cloud)
- Simplified cluster lifecycle management
- Edge computing scenarios

**Note:** Omni is not a traditional Cluster API provider but rather a complete cluster management platform that can work alongside or instead of Cluster API.

**Links:**

- <https://github.com/siderolabs/omni>
- <https://omni.siderolabs.com/>

### Hivelocity

A commercial bare metal cloud provider with Cluster API integration.

**Key Features:**

- Managed bare metal infrastructure
- Global data center presence
- API-driven provisioning
- Network configuration management
- Storage options

**Use Cases:**

- Organizations needing managed bare metal
- Multi-region bare metal deployments
- Hybrid cloud scenarios

**Links:**

- <https://github.com/hivelocity/cluster-api-provider-hivelocity>
- <https://www.hivelocity.net/>

## Flexible/Hybrid Providers

### BYOH (Bring Your Own Host)

The most flexible option for existing bare metal infrastructure.

**Key Features:**

- SSH-based host registration
- No special hardware requirements
- Works with any Linux distribution
- Agent-based approach
- Supports existing infrastructure

**Architecture:**

- Lightweight host agent
- SSH connectivity
- No PXE boot required
- No BMC/IPMI requirements

**Use Cases:**

- Legacy bare metal infrastructure
- Heterogeneous environments
- Quick proof-of-concept deployments
- Environments without IPMI/Redfish

**Get started:**

```shell
clusterctl init --infrastructure byoh
```

**Links:**

- <https://github.com/kubernetes-sigs/cluster-api-provider-bringyourownhost>

### MAAS (Metal as a Service)

Canonical's bare metal provisioning solution.

**Key Features:**

- Comprehensive hardware management
- Network configuration automation
- Storage configuration
- Integration with Juju
- Web UI and API

**Architecture:**

- Central MAAS server
- Rack and region controllers
- PXE boot infrastructure
- Image management

**Use Cases:**

- Ubuntu-centric environments
- Organizations using Canonical stack
- Large-scale bare metal deployments

**Links:**

- <https://github.com/spectrocloud/cluster-api-provider-maas>
- <https://maas.io/>

### k0smotron RemoteMachine

SSH-based remote machine provisioning.

**Key Features:**

- SSH connectivity
- k0s distribution focus
- Simple deployment model
- No agent required on target

**Use Cases:**

- k0s Kubernetes distributions
- Simple bare metal scenarios
- Remote server provisioning

**Links:**

- <https://github.com/k0sproject/k0smotron>

## Provider Comparison

| Provider | Maturity | Complexity | Hardware Discovery | Boot Method | Special Requirements |
|----------|----------|------------|-------------------|-------------|---------------------|
| Metal3 | High | Medium-High | Yes | PXE/iPXE | IPMI/Redfish |
| Tinkerbell | Medium | Medium | Yes | PXE | DHCP/TFTP infrastructure |
| Sidero | Medium (Community) | Medium | Yes | PXE | Talos Linux (not actively developed) |
| Omni | Medium | Low | No | Agent-based | Talos Linux, Omni account |
| Hivelocity | Medium | Low | N/A | Managed | Hivelocity account |
| BYOH | Medium | Low | No | N/A | SSH access |
| MAAS | High | Medium-High | Yes | PXE | MAAS server |
| k0smotron | Low-Medium | Low | No | N/A | SSH access |

## Choosing a Provider

### When to use Metal3

- Standard bare metal with IPMI/Redfish
- Need hardware introspection
- Want mature, community-supported solution
- OpenStack Ironic familiarity

### When to use Tinkerbell

- Need flexible, workflow-based provisioning
- Modern microservices architecture preference
- Custom provisioning requirements
- Building bare metal platform

### When to use Omni

- Standardizing on Talos Linux
- Want managed cluster lifecycle
- Multi-cluster, multi-environment deployments
- Prefer SaaS or simplified operations
- Security is primary concern
- Need GitOps integration

### When to use Sidero

- Existing Sidero deployments (migration not required)
- Community support is acceptable
- Cannot use Omni (on-premises only, no SaaS)
- **For new deployments:** Consider Omni, Metal3, or BYOH instead

### When to use BYOH

- Working with existing infrastructure
- No IPMI/Redfish available
- Quick testing/POC
- Heterogeneous hardware
- SSH access only

### When to use MAAS

- Ubuntu environment
- Need comprehensive hardware lifecycle
- Want integrated networking/storage
- Canonical ecosystem

## Getting Provider Information

List all available infrastructure providers:

```shell
clusterctl config repositories | grep InfrastructureProvider
```

Get specific provider versions:

```shell
clusterctl config repositories | grep InfrastructureProvider | grep metal3
```

## Common Requirements

Most bare metal providers share these requirements:

1. **Network Infrastructure**
   - DHCP server (for PXE-based providers)
   - TFTP server (for network boot)
   - DNS resolution
   - Network connectivity to BMC interfaces

2. **Management Network**
   - Separate management network for BMC/IPMI
   - Out-of-band management access
   - Network segmentation

3. **Storage**
   - Boot images repository
   - OS image storage
   - Container registry access

4. **Credentials**
   - BMC/IPMI credentials
   - SSH keys
   - API tokens (for cloud bare metal)

## Best Practices

1. **Start Simple**: Begin with BYOH for testing, migrate to full-featured providers for production
2. **Network Planning**: Design network topology before deployment
3. **Credential Management**: Use secrets management for BMC credentials
4. **Image Management**: Maintain updated OS images
5. **Monitoring**: Implement hardware monitoring (temperature, power, etc.)
6. **Documentation**: Document hardware inventory and network topology

## Additional Resources

- [Cluster API Providers Reference](https://cluster-api.sigs.k8s.io/reference/providers)
- [Cluster API Book](https://cluster-api.sigs.k8s.io/)
- [Metal3 Documentation](https://book.metal3.io/)
- [Tinkerbell Documentation](https://docs.tinkerbell.org/)
- [Omni Documentation](https://omni.siderolabs.com/docs/)
- [Talos Linux Documentation](https://www.talos.dev/)
