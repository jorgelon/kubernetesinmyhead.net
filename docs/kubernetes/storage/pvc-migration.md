# PVC cross-cluster migration

When two Kubernetes clusters have no direct network connectivity between them,
migrating PVC data requires an intermediate storage layer reachable from both
sides. The typical approach is to use an S3-compatible object store as a relay:
the source cluster writes data to the bucket, and the destination cluster reads
from it independently.

This page describes the available tools for this pattern. The choice of cloud
provider does not matter — all tools listed here are cloud-agnostic as long as
an S3-compatible endpoint is accessible from both clusters.

## Prerequisites

- Access to both clusters via `kubectl`
- An S3-compatible bucket reachable from both clusters over the internet
- Credentials with read/write access to the bucket available in both clusters
- The destination cluster must have a compatible StorageClass
- The workload using the source PVC should be scaled down before migration to
  ensure data consistency

## Tools

### [pv-migrate](https://github.com/utkuozdemir/pv-migrate)

Open-source CLI tool purpose-built for PVC migration between Kubernetes clusters.
It supports a dedicated backup/restore mode that uses rclone internally to push
PVC data to an S3-compatible bucket, Azure Blob Storage, or GCS. The backup and
restore operations are independent, making it well-suited for air-gapped or
isolated cluster scenarios. It does not require any in-cluster components beyond
the Jobs it spawns during the operation.

### [rclone](https://rclone.org/)

General-purpose cloud sync tool that supports over 70 storage providers
including S3, GCS, Azure Blob, and many others. It can be run inside a
Kubernetes Job by mounting the source or destination PVC and syncing its
contents to or from the remote bucket. Since it is not Kubernetes-native, it
requires manual Job authoring, but it gives full control over the transfer
without additional platform dependencies.

### [Velero](https://velero.io/docs/)

The de-facto standard for Kubernetes backup and disaster recovery. Velero
supports cross-cluster migration by using a shared S3 bucket as the source of
truth: a backup is taken on the source cluster and a restore is triggered on the
destination cluster. It handles both Kubernetes resource manifests and PVC data
(via Restic or Kopia for file-level backups, or via CSI snapshots). It requires
installation on both clusters and is better suited when full namespace or cluster
migration is needed alongside the volume data.

### [Restic](https://restic.net/)

Standalone backup tool that can be run inside a Kubernetes pod. It encrypts and
deduplicates data before sending it to a remote backend including S3, GCS, Azure,
and SFTP. It gives fine-grained control over backup scheduling via CronJobs and
is lightweight compared to full platforms like Velero. Velero can optionally use
Restic as its data movement layer, though it has been deprecated in favour of
Kopia since Velero v1.15.

### [Kopia](https://kopia.io/)

Modern alternative to Restic with significantly higher throughput due to parallel
upload streams. It supports block-level deduplication and compression, and
handles large volumes more efficiently. Velero adopted Kopia as its recommended
data mover replacing Restic since v1.10. It can also be used standalone inside a
pod in the same pattern as Restic.

### [Kasten K10](https://www.kasten.io/)

Enterprise-grade Kubernetes data management platform by Veeam. It provides a web
UI, policy-based backup scheduling, application-consistent snapshots, and
cross-cluster restore workflows. It supports S3-compatible storage as a backup
target and is capable of restoring into a different cluster regardless of cloud
provider. A free community tier is available for clusters up to five nodes.

### [TrilioVault](https://trilio.io/)

Enterprise backup and recovery solution for Kubernetes. It supports S3-compatible
object storage and NFS as backup targets and is designed to work across
heterogeneous infrastructure, making it suitable for cross-cloud restore scenarios.
It focuses on application-level consistency and provides namespace-level granularity
for backups and restores.

### [Stash by AppsCode](https://stash.run/)

Declarative, GitOps-native backup tool built on top of Restic. Backup and restore
policies are defined as Kubernetes custom resources, making it easy to manage
through a GitOps workflow. It supports S3 and other remote backends and integrates
with several database operators for application-consistent backups.

## Comparison table

Stats collected in May 2026.

| Tool                                                    | License      | GitHub stars | Contributors | CNCF                              |
|---------------------------------------------------------|--------------|--------------|--------------|-----------------------------------|
| [pv-migrate](https://github.com/utkuozdemir/pv-migrate) | Apache 2.0   | ~2.3k        | 18           | No                                |
| [rclone](https://github.com/rclone/rclone)              | MIT          | ~57k         | ~410         | No                                |
| [Velero](https://github.com/vmware-tanzu/velero)        | Apache 2.0   | ~10k         | ~302         | Sandbox (2026)                    |
| [Restic](https://github.com/restic/restic)              | BSD 2-Clause | ~33.5k       | ~473         | No                                |
| [Kopia](https://github.com/kopia/kopia)                 | Apache 2.0   | ~13.2k       | ~146         | No                                |
| [Kasten K10](https://www.kasten.io/)                    | Commercial   | N/A          | N/A          | No (vendor: CNCF Platinum member) |
| [TrilioVault](https://trilio.io/)                       | Commercial   | N/A          | N/A          | No                                |
| [Stash by AppsCode](https://github.com/stashed/stash)   | PolyForm     | ~1.4k        | 26           | No                                |

> Velero was accepted into the CNCF Sandbox in February 2026 after being
> donated by Broadcom. Kasten's companion open-source framework
> [Kanister](https://github.com/kanisterio/kanister) is a separate CNCF Sandbox
> project (accepted September 2023).

## Links

- [Kubernetes Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [CNCF Landscape — backup category](https://landscape.cncf.io/)
- [Velero CNCF Sandbox announcement](https://www.techzine.eu/news/infrastructure/139783/broadcom-ships-vks-3-6-and-moves-velero-to-cncf-sandbox/)
- [Restic vs Kopia performance comparison](https://cloudcasa.io/blog/comparing-restic-vs-kopia-for-kubernetes-data-movement/)
