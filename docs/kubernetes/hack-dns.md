# Hack dns

## Redirect internal service to external fqdn

We can redirect the dns resolution of an internal service to an external fqdn

We can achieve this using an external name service. With the following example, "my-service" will return "my.fqdn.url"

```yaml
kind: Service
apiVersion: v1
metadata:
  name: my-service
spec:
  type: ExternalName
  externalName: my.fqdn.url
```

## Redirect external fqdn to internal service

We can do that changing coredns configuration. For example this line redirects "my.fqdn.url" to "my-service.default.svc.cluster.local"

```yaml
apiVersion: v1
data:
  Corefile: |
    .:53 {
        rewrite name my.fqdn.url my-service.default.svc.cluster.local
        ...
    }
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
```

> This needs to restart coredns deployment

<https://coredns.io/2017/05/08/custom-dns-entries-for-kubernetes/>

## Redirect an domain to a custom dns server

We can redirect all domain resolutions to a custom dns server

```yaml
apiVersion: v1
data:
  Corefile: |
    .:53 {
        forward graphenus.internal my.dnsserver.ip
        ...
    }
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
```

<https://coredns.io/manual/setups/>

## Custom dns entries in a pod

In pod spec.hostAliases we can set a list of entries that contains a hostname and an ip to give custom resolutions to a pod. This adds a /etc/hosts entry

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test
spec:
  hostAliases:
  - ip: "127.0.0.1"
    hostnames:
    - "foo.local"
    - "bar.local"
  - ip: "10.1.2.3"
    hostnames:
    - "foo.remote"
    - "bar.remote"
  ...
```

<https://kubernetes.io/docs/tasks/network/customize-hosts-file-for-pods/>

## Core dns in EKS

<https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html>

<https://repost.aws/knowledge-center/eks-conditional-forwarder-coredns>
