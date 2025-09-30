# On premise load balancers

On-premise Kubernetes load balancers provide LoadBalancer service type support for clusters running outside of cloud providers. While cloud providers automatically provision load balancers for LoadBalancer services, on-premise clusters need additional solutions to expose services externally. These load balancers typically work by assigning external IP addresses from a pool and using BGP, ARP, or Layer 2 protocols to advertise these IPs to the network infrastructure, making services accessible from outside the cluster.

## Cilium LoadBalancer IP Address Management (LB IPAM)

Cilium's LB IPAM feature provides LoadBalancer service type support for on-premise clusters by automatically managing IP address allocation and assignment for load balancer services.

- **Website**: <https://cilium.io/>
- **GitHub**: <https://github.com/cilium/cilium>
- **Documentation**: <https://docs.cilium.io/en/stable/network/lb-ipam/>
- **Stats**: ⭐ 22.5k stars, 👥 1000+ contributors
- **Language**: Go, eBPF
- **Companies**: Isovalent
- **CNCF Relation**: Graduated project

## MetalLB

MetalLB is a load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.

- **Website**: <https://metallb.universe.tf/>
- **GitHub**: <https://github.com/metallb/metallb>
- **Stats**: ⭐ 7.8k stars, 👥 210+ contributors
- **Language**: Go (68.6%)
- **Companies**: Community-driven
- **CNCF Relation**: Sandbox project

## Kube-VIP

Kube-VIP provides Kubernetes Virtual IP and Load-Balancer for both control plane and Kubernetes services in bare-metal, edge, and virtualization environments.

- **GitHub**: <https://github.com/kube-vip/kube-vip>
- **Stats**: ⭐ 2.6k stars, 👥 98 contributors
- **Language**: Go (95.5%)
- **Companies**: Community-driven
- **CNCF Relation**: Sandbox project

## loxilb.io

loxilb.io is a cloud-native load balancer for Kubernetes that provides high-performance layer 4 load balancing and can run in standalone mode or as a Kubernetes operator.

- **Website**: <https://loxilb.io/>
- **GitHub**: <https://github.com/loxilb-io/loxilb>
- **Stats**: ⭐ 1.8k stars, 👥 Active contributors
- **Language**: Go
- **Companies**: Community-driven
- **CNCF Relation**: Sandbox project

## PureLB

PureLB is a load-balancer orchestrator for Kubernetes clusters that uses standard Linux networking and routing protocols, inspired by MetalLB.

- **Website**: <https://purelb.gitlab.io/purelb/>
- **GitHub**: <https://github.com/purelb/purelb>
- **Stats**: ⭐ 111 stars, 👥 76 contributors
- **Language**: Go (96.8%)
- **Companies**: Community-driven
- **CNCF Relation**: Not a CNCF project
