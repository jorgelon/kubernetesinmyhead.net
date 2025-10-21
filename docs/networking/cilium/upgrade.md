# Upgrade cilium

## Preparation

### If upgrading to a new minor version

- First update to the latest patch version of the current minor version.

- Read the release notes documentation for the new minor version, for example

```yaml
https://docs.cilium.io/en/v1.16/operations/upgrade/#upgrade-notes # when upgrading to 1.16
https://docs.cilium.io/en/v1.17/operations/upgrade/#upgrade-notes # when upgrading to 1.17
https://docs.cilium.io/en/v1.18/operations/upgrade/#upgrade-notes # when upgrading to 1.18
```

### Deploy a pre-flight check

The preflight

```yaml
preflight:
  enabled: true
agent: false
operator:
  enabled: false
```

> Remember to delete the pre-flight check at the end

### upgradeCompatibility

The upgradeCompatibility setting minimizes "datapath disruption during the upgrade". Configure it with the initial cilium version installed in the cluster

## Links

- Upgrade Guide

<https://docs.cilium.io/en/stable/operations/upgrade>
