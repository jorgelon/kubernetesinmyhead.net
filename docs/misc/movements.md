# Movements

## Acquisitions

### IBM

#### Red Hat

Acquired by IBM in 2019 for $34 billion.

#### CentOS

Community rebuild of RHEL, originally independent. Red Hat took over sponsorship and in 2020 shifted CentOS from a downstream RHEL rebuild to CentOS Stream (upstream rolling release), discontinuing CentOS 8 in December 2021.

Forks: Rocky Linux, AlmaLinux

#### CoreOS

Container-focused Linux distribution acquired by Red Hat in 2018. Container Linux was deprecated and replaced by Red Hat CoreOS (RHCOS), now the base OS for OpenShift nodes. The CoreOS team also contributed etcd (now a CNCF graduated project).

#### HashiCorp

License changed from MPL-2.0 to BSL 1.1 in August 2023 (see [License Changes](#license-changes)), then acquired by IBM in April 2024 for $6.4 billion.

#### Kubecost

Kubernetes cost optimization startup acquired by IBM in September 2024.

<https://techcrunch.com/2024/09/17/ibm-acquires-kubernetes-cost-optimization-startup-kubecost/>

### Broadcom

#### VMware

Acquired by Broadcom in November 2023 for ~$69 billion. Broadcom discontinued free products (vSphere Hypervisor/ESXi free tier), moved all licensing to subscriptions, and significantly reduced open-source contributions across VMware Tanzu projects.

#### Carvel

Suite of Kubernetes tools (ytt, kapp, kbld, imgpkg, vendir, kapp-controller) originally created by the VMware Tanzu team. Donated to CNCF as a sandbox project in 2022. After the Broadcom acquisition, corporate sponsorship was significantly reduced, leaving the project mainly community-driven.

### Cisco

#### Isovalent

Company behind Cilium and Tetragon, acquired by Cisco in January 2024. Isovalent was founded by the original creators of Cilium and was the primary corporate maintainer of the project.

#### Cilium

eBPF-based CNI plugin for Kubernetes networking, observability, and security, created by Isovalent. CNCF graduated project. After the Cisco acquisition, development continues under Cisco's cloud networking portfolio.

### F5

#### NGINX

High-performance web server, reverse proxy, and load balancer acquired by F5 in 2019. NGINX remains widely used as an ingress controller in Kubernetes (ingress-nginx). The open-source project continues, but commercial development is driven by F5.

### Microsoft

#### GitHub

Acquired by Microsoft in 2018 for $7.5 billion. Remains the largest code hosting platform and continues to operate largely independently under Microsoft ownership.

#### Kinvolk

Berlin-based Linux and Kubernetes infrastructure company acquired by Microsoft in April 2021. Kinvolk created Flatcar Container Linux (a community fork of CoreOS Container Linux after Red Hat deprecated it) and Headlamp (open-source Kubernetes UI). The acquisition strengthened Azure's Linux and container expertise.

### Mirantis

#### Docker Enterprise

Mirantis acquired Docker's enterprise business (Docker Enterprise, UCP, DTR) in November 2019. Docker Inc retained Docker Desktop, Docker Hub, and the Docker CLI/Engine open-source projects.

### Progress Software

#### Chef

Configuration management and infrastructure automation platform acquired by Progress Software in October 2020. Chef (including InSpec and Habitat) continues under Progress ownership.

### Pure Storage

#### Portworx

Kubernetes-native storage platform acquired by Pure Storage in 2020. Portworx provides persistent storage, data protection, and disaster recovery for stateful workloads on Kubernetes.

### SUSE

#### Rancher Labs

Kubernetes management platform acquired by SUSE in December 2020. Rancher provides multi-cluster Kubernetes management and remains a major open-source project under SUSE ownership.

## License Changes

### MongoDB

Changed from AGPL to SSPL (Server Side Public License) in October 2018. MongoDB pioneered the SSPL approach, specifically targeting cloud providers offering MongoDB as a managed service. This triggered broader industry debate and influenced later license changes by Elastic, Redis, and HashiCorp.

### CockroachDB

CockroachDB changed from Apache 2.0 to BSL 1.1 (Business Source License) in 2019, the same approach later adopted by HashiCorp. BSL restricts production use by competing database-as-a-service providers.

Fork: CockroachDB has a community version; YugabyteDB is a comparable open-source alternative.

### HashiCorp

License changed from MPL-2.0 to BSL 1.1 in August 2023, restricting competitive use of tools like Terraform, Vault, and Consul. Later acquired by IBM (see [Acquisitions](#acquisitions)).

Fork: OpenTofu (Terraform fork, CNCF sandbox project)

### Elasticsearch

Elastic changed the license from Apache 2.0 to SSPL + Elastic License in January 2021, preventing cloud providers from offering managed Elasticsearch without contributing back.

Fork: OpenSearch (by AWS, Apache 2.0 licensed)

### Grafana

Grafana Labs changed the license of Grafana, Loki, Tempo, and Mimir from Apache 2.0 to AGPL v3 in 2021. AGPL requires network service providers to publish their modifications, effectively targeting SaaS providers who embed Grafana without contributing back.

### Buoyant / Linkerd

Buoyant did not change the Linkerd project license (Apache 2.0) but in 2023 stopped publishing pre-built stable release artifacts. Users must now build from source or use Buoyant's commercial distribution. The CNCF project continues but the distribution model effectively pushes production users toward the paid offering.

### Redis

Redis Ltd changed the license from BSD to RSALv2 + SSPLv1 in March 2024.

Forks: Valkey (CNCF sandbox, Linux Foundation), Redict

## Company Shutdowns

### Weaveworks (February 2024)

Pioneering cloud-native company behind Flux (GitOps, CNCF graduated) and WeaveNet (CNI plugin). Weaveworks shut down in February 2024 citing difficult market conditions. Both projects continue under CNCF governance independently of the company.
