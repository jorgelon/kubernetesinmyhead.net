# Cloud Cost Solutions

Open-source solutions for monitoring and analyzing cloud costs in Kubernetes environments.

## OpenCost

[OpenCost](https://www.opencost.io/) is a vendor-neutral open-source project for measuring and allocating infrastructure and container costs in real-time. It's a CNCF Incubating project that provides cost visibility for Kubernetes workloads.

- **GitHub Stars**: 6.1k
- **Contributors**: 140
- **Company Behind**: Originally developed by Kubecost (Stackwatch Inc.), now owned by IBM (since September 2024)
- **CNCF Status**: Incubating (accepted as Sandbox in June 2022, promoted to Incubating in October 2024)
- **CNCF Member**: IBM is a founding member of CNCF (2015)
- **Contributing Organizations**: Kubecost, RedHat, AWS, Adobe, SUSE, Armory, Google Cloud, Pixie, Mindcurv, D2IQ, New Relic

### OpenCost References

- [Official Documentation](https://www.opencost.io/docs/)
- [GitHub Repository](https://github.com/opencost/opencost)
- [Helm Chart](https://github.com/opencost/opencost-helm-chart)

## Kubecost

[Kubecost](https://www.kubecost.com/) provides real-time cost visibility and insights for Kubernetes clusters. While it offers commercial enterprise features, the core product (formerly known as Kubecost Free) is available as open-source and provides comprehensive cost monitoring capabilities.

- **GitHub Stars**: 577
- **Contributors**: 150+
- **Company Behind**: Kubecost (Stackwatch Inc.), acquired by IBM in September 2024
- **CNCF Relation**: Not a CNCF project (commercial product), but created and donated OpenCost to CNCF
- **CNCF Member**: Kubecost was a CNCF member; now part of IBM (CNCF founding member)

### Kubecost References

- [Official Documentation](https://docs.kubecost.com/)
- [GitHub Repository](https://github.com/kubecost/cost-analyzer-helm-chart)
- [Kubecost Blog](https://blog.kubecost.com/)

## Grafana Cloud Cost Exporter

[Grafana Cloud Cost Exporter](https://github.com/grafana/cloudcost-exporter) is an open-source Prometheus exporter that collects cloud provider cost metrics and makes them available for visualization in Grafana dashboards. It focuses on exporting billing data as Prometheus metrics rather than providing a complete cost allocation platform.

- **GitHub Stars**: 102
- **Contributors**: 18+
- **Company Behind**: Grafana Labs
- **CNCF Relation**: Not a CNCF project, but Grafana Labs contributes to OpenCost and other CNCF projects
- **CNCF Member**: Grafana Labs is a CNCF Platinum member (upgraded from Silver in July 2021)

### Grafana Cloud Cost Exporter References

- [GitHub Repository](https://github.com/grafana/cloudcost-exporter)
- [Grafana Cloud Cost Dashboards](https://grafana.com/grafana/dashboards/)
- [AWS Cost Explorer API](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-api.html)
- [Azure Cost Management API](https://learn.microsoft.com/en-us/rest/api/cost-management/)
- [GCP Billing Export](https://cloud.google.com/billing/docs/how-to/export-data-bigquery)
