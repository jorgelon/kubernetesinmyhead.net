# Metrics for ingress and certificates

## Tools

- Kube state metrics

It gets info about kubernetes secrets but it needs a customresourceconfig to check the expiration field

<https://github.com/kubernetes/kube-state-metrics/blob/main/docs/metrics/extend/customresourcestate-metrics.md>

- Blackbox exporter

The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

<https://github.com/prometheus/blackbox_exporter>

- X.509 Certificate Exporter

<https://github.com/enix/x509-certificate-exporter>

Generate metrics for certificates, with focus on expiration
