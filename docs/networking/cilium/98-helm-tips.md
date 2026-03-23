# Helm tips

## cluster name

Give a name to your cluster

```yaml
cluster:
  name: hyperv-testing
```

## upgradeCompatibility

Give the deployment the same upgradeCompatibility of the initial cilium deployed release "To minimize datapath disruption during the upgrade"

```yaml
upgradeCompatibility: "1.16"
```

<https://docs.cilium.io/en/stable/operations/upgrade/>

## Hubble certs refresh

Enable automatic refresh method of the hubble certificates. For example

```yaml
hubble:
  tls:
    auto:
      method: cronJob
```

## Other

- Configure the proper resources (requests and limits) to all the cilium pods
- Enable the metrics <https://docs.cilium.io/en/stable/observability/metrics/>
