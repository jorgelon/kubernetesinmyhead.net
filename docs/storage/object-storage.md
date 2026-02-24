# Self-Hosted Object Storage Solutions

Open source and source-available options for self-hosted S3-compatible object storage.

> Note: MinIO's open source (Apache 2.0) version is archived. The current MinIO is AGPL-3.0, which restricts commercial use without a commercial license.

---

## Kubernetes-Native

Solutions with native Kubernetes integration: operators, CSI drivers, or CNCF project status.

### CubeFS

**License**: Apache 2.0
**S3-compatible**: Yes (native, also POSIX and HDFS)
**CNCF status**: Graduated (January 2025)
**GitHub**: <https://github.com/cubefs/cubefs>

A distributed storage system supporting multiple access protocols: S3, POSIX, and HDFS. Originally developed at JD.com and donated to the CNCF in 2019, it graduated in January 2025. Over 200 organisations run it in production, managing approximately 350 PB of data.

**Strengths**:

- Apache 2.0 license
- Multi-protocol: S3, POSIX, HDFS in a single system
- Dual storage engines: multi-replica and erasure coding
- Kubernetes CSI plugin included
- Multi-tenancy with fine-grained isolation
- Scales to PB/EB level
- Strong CNCF governance and security audit

**Weaknesses**:

- Relatively unknown outside Asian cloud/e-commerce companies
- Operational complexity comparable to Ceph
- Documentation still maturing for Western audiences

**Use when**: You need an Apache-licensed, CNCF-graduated storage system with S3, POSIX, and HDFS in one platform, especially for AI/ML or big data workloads alongside Kubernetes.

---

### Ceph (RGW)

**License**: LGPL-2.1
**S3-compatible**: Yes (via RADOS Gateway)
**CNCF status**: Not a CNCF project — Rook (its Kubernetes operator) is CNCF Graduated
**Kubernetes operator**: [Rook](https://rook.io)

The most battle-tested distributed storage system in the cloud-native ecosystem. Ceph provides object (S3/Swift), block (RBD), and file (CephFS) storage in a single platform.

**Strengths**:

- Mature, production-proven at scale
- Multi-protocol: S3, Swift, NFS, iSCSI, RBD
- Self-healing and self-managing
- Rook operator makes Kubernetes deployment straightforward

**Weaknesses**:

- High operational complexity
- Requires significant resources (minimum 3 nodes recommended)
- Steep learning curve

**Use when**: You need a full-featured, production-grade storage platform and have the operational capacity to manage it.

---

### SeaweedFS

**License**: Apache 2.0
**S3-compatible**: Yes
**CNCF status**: Not a CNCF project
**CSI driver**: [seaweedfs-csi-driver](https://github.com/seaweedfs/seaweedfs-csi-driver)
**GitHub**: <https://github.com/seaweedfs/seaweedfs>

A distributed file system with S3-compatible API, optimized for storing billions of small files efficiently. Has a dedicated CSI driver for Kubernetes persistent volumes.

**Strengths**:

- Apache 2.0 license
- Excellent performance for small files
- Low overhead per file (metadata optimization)
- S3, POSIX (FUSE), HDFS interfaces
- CSI driver for Kubernetes PVCs
- Active development

**Weaknesses**:

- Less mature than Ceph for enterprise workloads
- Smaller ecosystem
- No CNCF backing

**Use when**: You need Apache 2.0-licensed S3-compatible storage, especially with many small objects, with Kubernetes PVC support.

---

## General Self-Hosted

Solutions designed to run anywhere. Can be deployed on Kubernetes but are not primarily Kubernetes-oriented.

### RustFS

**License**: Apache 2.0
**S3-compatible**: Yes
**Maturity**: Alpha (distributed mode still under testing)
**GitHub**: <https://github.com/rustfs/rustfs>

Written in Rust, explicitly positioned as an Apache 2.0 MinIO replacement. Claims 2.3x throughput of MinIO for 4KB objects. Single binary under 100MB. Has a Helm chart but no operator or CSI driver.

**Use when**: You need an Apache 2.0 MinIO drop-in replacement and are comfortable with alpha software. Watch this project.

---

### Garage

**License**: AGPL-3.0
**S3-compatible**: Yes
**GitHub**: <https://github.com/deuxfleurs-org/garage>

Lightweight, distributed object storage written in Rust, designed for geo-distribution across unreliable or heterogeneous nodes. Very low resource footprint. Strong choice for multi-site or edge deployments.

**Use when**: You need geo-distributed object storage across multiple sites with minimal operational overhead. Note the AGPL license.

---

### Alarik

**License**: Apache 2.0
**S3-compatible**: Yes
**Maturity**: Alpha — do not use in production
**GitHub**: <https://github.com/achtungsoftware/alarik>

Written in Swift (SwiftNIO). No GC pauses (ARC), built-in web console. Single node only, Linux only. Very early stage but worth watching as a lightweight Apache 2.0 option.

---

### OpenStack Swift

**License**: Apache 2.0
**S3-compatible**: Partial (via `s3api` middleware)
**Website**: <https://docs.openstack.org/swift>

The original OpenStack object storage. Very mature and proven at telco scale. S3 compatibility is not native. Only relevant if you are already operating an OpenStack environment.

---

### Zenko CloudServer (Scality)

**License**: Apache 2.0
**S3-compatible**: Yes (native)
**GitHub**: <https://github.com/scality/cloudserver>

Native S3 API implementation that can proxy to local disk, AWS S3, Azure Blob, or GCS. Lightweight. Suitable for development, testing, or as a routing layer in front of multiple backends. The broader Zenko platform is proprietary.

---

## Comparison

| Solution            | License    | S3-Native | CNCF Status        | K8s Integration    | Complexity | Scale        |
|---------------------|------------|-----------|--------------------|--------------------|------------|--------------|
| CubeFS              | Apache 2.0 | Yes       | Graduated (2025)   | CSI + Helm         | Medium     | Large (PB+)  |
| Ceph (Rook)         | LGPL-2.1   | Yes       | Rook is Graduated  | Operator + Helm    | High       | Large        |
| SeaweedFS           | Apache 2.0 | Yes       | -                  | CSI + Helm         | Medium     | Medium/Large |
| RustFS              | Apache 2.0 | Yes       | -                  | Helm only (Alpha)  | Low        | - (Alpha)    |
| Garage              | AGPL-3.0   | Yes       | -                  | Helm only          | Low        | Medium       |
| Alarik              | Apache 2.0 | Yes       | -                  | None (Alpha)       | Low        | - (Alpha)    |
| OpenStack Swift     | Apache 2.0 | Partial   | -                  | None               | High       | Large        |
| Zenko CloudServer   | Apache 2.0 | Yes       | -                  | Docker/K8s         | Low        | Small/Medium |

---

## Links

- [CubeFS documentation](https://cubefs.io/docs/master/overview/introduction.html)
- [CubeFS CNCF graduation announcement](https://www.cncf.io/announcements/2025/01/21/cloud-native-computing-foundation-announces-cubefs-graduation/)
- [Rook documentation](https://rook.io/docs/rook/latest)
- [SeaweedFS GitHub](https://github.com/seaweedfs/seaweedfs)
- [RustFS GitHub](https://github.com/rustfs/rustfs)
- [Garage documentation](https://garagehq.deuxfleurs.fr/documentation/quick-start/)
- [Alarik GitHub](https://github.com/achtungsoftware/alarik)
- [OpenStack Swift](https://docs.openstack.org/swift/latest/)
- [Zenko CloudServer GitHub](https://github.com/scality/cloudserver)
- [CNCF Landscape - Cloud Native Storage](https://landscape.cncf.io/?category=cloud-native-storage&grouping=category)
