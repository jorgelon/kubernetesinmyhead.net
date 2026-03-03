# Labels

Labels used in NodePool `requirements` to control which EC2 instances Karpenter provisions.
Community Karpenter uses the `karpenter.k8s.aws/` prefix; EKS Auto Mode uses `eks.amazonaws.com/`.

## Hypervisor

### `karpenter.k8s.aws/instance-hypervisor`

Filters instances by the underlying hypervisor technology.

| Value   | Description                                                                                        |
|---------|----------------------------------------------------------------------------------------------------|
| `nitro` | AWS Nitro System — modern instances (gen 5+). Better performance, security, and network throughput |
| `xen`   | Xen hypervisor — older instances (gen 1–4)                                                         |
| `none`  | Bare metal instances — no hypervisor layer                                                         |

### `kubernetes.io/arch`

CPU architecture of the node.

| Value   | Description                          |
|---------|--------------------------------------|
| `amd64` | x86_64 — Intel and AMD processors    |
| `arm64` | ARM 64-bit — AWS Graviton processors |

### `kubernetes.io/os`

Operating system of the node. EKS Auto Mode only supports `linux`.

| Value     | Description                              |
|-----------|------------------------------------------|
| `linux`   | Linux                                    |
| `windows` | Windows — not supported in EKS Auto Mode |

## Instance type

### `karpenter.k8s.aws/instance-generation`

Generation number of the instance type within its category. Integer value, e.g. `4`, `6`, `7`, `8`.
Higher generation generally means better price/performance ratio.

Use `Gt` to require a minimum generation:

```yaml
- key: karpenter.k8s.aws/instance-generation
  operator: Gt
  values: ["5"]
```

### `karpenter.k8s.aws/instance-size`

Size tier of the instance within its family. Controls the overall resource scale.

Common values: `large`, `xlarge`, `2xlarge`, `4xlarge`, `8xlarge`, `12xlarge`, `16xlarge`,
`24xlarge`, `32xlarge`, `metal`

## CPU related

### `karpenter.k8s.aws/instance-cpu`

Number of vCPUs on the instance. Integer value, e.g. `2`, `4`, `8`, `16`, `32`, `64`, `96`, `192`.

### `karpenter.k8s.aws/instance-cpu-manufacturer`

Manufacturer of the CPU. Useful for workloads optimised for a specific architecture or to avoid a vendor.

| Value   | Description                                 | Typical instance families       |
|---------|---------------------------------------------|---------------------------------|
| `intel` | Intel Xeon (Ice Lake, Sapphire Rapids, ...) | `m7i`, `c7i`, `r7i`, `c6i`, ... |
| `amd`   | AMD EPYC                                    | `m7a`, `c7a`, `r7a`, `t3a`, ... |
| `aws`   | AWS Graviton (ARM)                          | `m7g`, `c7g`, `r7g`, `t4g`, ... |

### `karpenter.k8s.aws/instance-cpu-sustained-clock-speed-mhz`

Sustained CPU clock speed in MHz. Integer value, e.g. `3600`.

> Not available in EKS Auto Mode.

## Storage related

### `karpenter.k8s.aws/instance-ebs-bandwidth`

Maximum EBS bandwidth in Mbps. Integer value, e.g. `3170`, `9500`, `19000`.

Use `Gt` to guarantee a minimum EBS throughput for storage-intensive workloads.

## Memory

### `karpenter.k8s.aws/instance-memory`

Total memory of the instance in MiB. Integer value, e.g. `8192` (8 GiB), `32768` (32 GiB),
`131072` (128 GiB).

## Network

### `karpenter.k8s.aws/instance-network-bandwidth`

Baseline network bandwidth in Mbps. Integer value, e.g. `1876`, `5000`, `25000`.

Use `Gt` to require a minimum network throughput:

```yaml
- key: karpenter.k8s.aws/instance-network-bandwidth
  operator: Gt
  values: ["4999"]
```
