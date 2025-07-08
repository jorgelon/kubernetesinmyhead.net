# Tips

## Cilium pod does not start in flatcar

During some months/years, the defaul cilium installation did not start with flatcar.
To make it work, it was neccesary to change the user domain from spc_to to unconfined_t in the cilium installation.

The setting in helm chart

```yaml
securityContext:
  seLinuxOptions:
    type: unconfined_t
```

> Today this problem seems to be solved

See more here

- Cilium CNi with k8s does not work with SELinux in permissive mode #891

<https://github.com/flatcar/Flatcar/issues/891>

## No inter node communication between pods in Vmware Vsphere

There is a bug in the vmxnet driver that makes the pods don't have inter node connectivity using vxlan. Cilium forward the packets to the overlay but they don't reach the destiation pod/service

The following command in the cilium agent

```shell
cilium-health status --verbose
```

shows

```txt
HTTP to agent:   Get "<http://10.42.4.211:4240/hello>": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
```

One solution is to change the tunnelPort to a different than the default one (8472)

The setting in helm chart

```yaml
tunnelPort: 8223
```

More info here

- Installation on Broadcom VMware ESXi / NSX

<https://docs.cilium.io/en/latest/installation/k8s-install-broadcom-vmware-esxi-nsx/>
