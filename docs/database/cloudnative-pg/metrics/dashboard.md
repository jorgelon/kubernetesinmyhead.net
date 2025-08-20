# Dashboard and alerts

## Official dashboard

The official cnpg grafana dashboard is located here

<https://github.com/cloudnative-pg/grafana-dashboards/blob/main/charts/cluster/grafana-dashboard.json>

> **Note**: This metric list is based on the current dashboard version. The required metrics may change when the dashboard is updated. Always verify against the latest dashboard version.

## Required Metrics

To make the official CNPG Grafana dashboard work, you need to ensure the following metrics are available in your Prometheus instance:

### CNPG Operator and Cluster Metrics

These metrics are provided by CloudNative-PG operator and PostgreSQL clusters:

```txt
cnpg_pg_replication_streaming_replicas
cnpg_pg_replication_is_wal_receiver_up
cnpg_pg_replication_lag
cnpg_pg_stat_replication_write_lag_seconds
cnpg_pg_stat_replication_flush_lag_seconds
cnpg_pg_stat_replication_replay_lag_seconds
cnpg_pg_postmaster_start_time
cnpg_pg_stat_database_xact_commit
cnpg_pg_stat_database_xact_rollback
cnpg_backends_total
cnpg_pg_settings_setting
cnpg_pg_replication_in_recovery
cnpg_pg_stat_archiver_seconds_since_last_archival
cnpg_collector_last_available_backup_timestamp
cnpg_collector_postgres_version
cnpg_pg_database_size_bytes
cnpg_collector_first_recoverability_point
```

### Kube State Metrics

These metrics are provided by kube-state-metrics:

```txt
kube_pod_container_resource_requests
kube_pod_status_ready
kube_pod_container_status_ready
kube_pod_info
kube_node_labels
```

### Kubelet Metrics

These metrics are exposed by the Kubelet:

```txt
kubelet_volume_stats_available_bytes
kubelet_volume_stats_capacity_bytes
kubelet_volume_stats_inodes_used
kubelet_volume_stats_inodes
```

### cAdvisor Metrics

These metrics are provided by cAdvisor (part of Kubelet):

```txt
container_memory_working_set_bytes
```

### Controller Runtime Metrics

These metrics are provided by the controller-runtime library (used by CNPG operator):

```txt
controller_runtime_reconcile_total
```

### Recording Rules

The dashboard requires this recording rule to be created:

```txt
node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate
```

This rule aggregates CPU usage rates by node, namespace, pod, and container dimensions.

**Required source metric**: The recording rule depends on `container_cpu_usage_seconds_total` which is provided by **cAdvisor** (part of Kubelet). This metric must be available in your Prometheus instance for the recording rule to work.

## Alerts

- Default provided alerts

 <https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/refs/heads/main/docs/src/samples/monitoring/alerts.yaml>
