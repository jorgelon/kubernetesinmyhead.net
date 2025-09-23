# Prometheus Long-Term Storage

## Overview

Prometheus, while excellent for real-time monitoring and short-term metric storage, has inherent limitations when it comes to long-term data retention and horizontal scalability. By default, Prometheus stores data locally and is designed for deployments lasting weeks to months rather than years.

This document explores five major open-source solutions that extend Prometheus capabilities for long-term storage: **Mimir**, **Cortex**, **Thanos**, **VictoriaMetrics**, and **GreptimeDB**.

## The Prometheus Storage Challenge

### Native Limitations

- **Local Storage Only**: Data stored on local disk, creating single points of failure
- **Limited Scalability**: Single-node architecture with vertical scaling limits
- **Retention Constraints**: Local storage capacity limits data retention periods
- **No High Availability**: Native Prometheus lacks built-in HA capabilities
- **Query Performance**: Performance degrades with large datasets and long retention periods

### Requirements for Long-Term Storage

- **Horizontal Scalability**: Ability to scale storage and compute independently
- **High Availability**: Redundancy and fault tolerance
- **Cost-Effective Storage**: Integration with object storage (S3, GCS, Azure Blob)
- **Global Querying**: Ability to query across multiple clusters and time ranges
- **Data Durability**: Protection against data loss
- **Performance**: Efficient querying across large datasets

## Solution Architectures

### Grafana Mimir

**Origin**: Fork of Cortex by Grafana Labs (2022)  
**Architecture**: Microservices-based with horizontal scaling  
**Repository**: [grafana/mimir](https://github.com/grafana/mimir) ⭐ 4.1k+ stars, 500+ contributors  
**CNCF Status**: Not a CNCF project (Grafana Labs proprietary)

#### Key Components

- **Distributor**: Receives metrics and forwards to ingesters
- **Ingester**: Writes metrics to storage and serves recent queries
- **Store Gateway**: Queries historical data from object storage
- **Query Frontend**: Optimizes and splits queries
- **Compactor**: Compacts and processes blocks in object storage
- **Ruler**: Evaluates recording and alerting rules

#### Architecture Benefits

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prometheus  │───▶│ Distributor │───▶│  Ingester   │
│   (Remote   │    │             │    │             │
│   Write)    │    └─────────────┘    └─────────────┘
└─────────────┘                             │
                                            ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Grafana   │◀───│Query Frontend│◀───│Object Storage│
│             │    │             │    │ (S3/GCS/etc)│
└─────────────┘    └─────────────┘    └─────────────┘
```

#### Features

- **Multi-Tenancy**: Native support with tenant isolation
- **Streaming**: Real-time query results streaming
- **Advanced Compaction**: Intelligent block compaction strategies
- **Autoscaling**: Kubernetes-native autoscaling support
- **Monitoring**: Extensive built-in observability

### Cortex

**Origin**: CNCF project originally developed by Weaveworks  
**Architecture**: Microservices-based, highly configurable  
**Repository**: [cortexproject/cortex](https://github.com/cortexproject/cortex) ⭐ 5.5k+ stars, 800+ contributors  
**CNCF Status**: Graduated project (2020)

#### Cortex Components

- **Distributor**: Load balances incoming metrics
- **Ingester**: Stores recent metrics in memory and periodically flushes to storage
- **Querier**: Handles PromQL queries
- **Query Frontend**: Splits and caches queries
- **Store Gateway**: Reads historical data from object storage
- **Compactor**: Compacts blocks and handles retention
- **Ruler**: Evaluates rules and generates alerts

#### Architecture Pattern

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prometheus  │───▶│ Distributor │───▶│  Ingester   │
│ (Remote     │    │             │    │ (Ring-based)│
│  Write)     │    └─────────────┘    └─────────────┘
└─────────────┘                             │
                                            ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Query     │◀───│   Querier   │◀───│Object Storage│
│  Frontend   │    │             │    │   Backend   │
└─────────────┘    └─────────────┘    └─────────────┘
```

#### Cortex Features

- **Flexible Deployment**: Multiple deployment modes (single binary, microservices)
- **Multi-Tenancy**: Comprehensive tenant isolation
- **Ring-based Architecture**: Consistent hashing for load distribution
- **Configurable Storage**: Multiple storage backend options
- **CNCF Graduated**: Mature project with strong community support

### Thanos

**Origin**: Developed by Improbable, now CNCF project  
**Architecture**: Sidecar-based approach with global querying  
**Repository**: [thanos-io/thanos](https://github.com/thanos-io/thanos) ⭐ 13k+ stars, 1,000+ contributors  
**CNCF Status**: Incubating project (2019)

#### Thanos Components

- **Sidecar**: Connects to Prometheus instances and uploads blocks
- **Store Gateway**: Provides unified interface to historical data
- **Query**: Global query layer across multiple Prometheus instances
- **Query Frontend**: Query optimization and caching
- **Compactor**: Compacts and downsamples historical data
- **Receiver**: Ingests metrics via remote write (alternative to sidecar)
- **Ruler**: Evaluates rules on historical data

#### Architecture Model

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prometheus A│◀──▶│Thanos Sidecar│   │Object Storage│
│             │    │             │──▶│   Backend   │
└─────────────┘    └─────────────┘    │             │
                                      │             │
┌─────────────┐    ┌─────────────┐    │             │
│ Prometheus B│◀──▶│Thanos Sidecar│──▶│             │
└─────────────┘    └─────────────┘    └─────────────┘
                                            ▲
┌─────────────┐    ┌─────────────┐          │
│   Grafana   │◀───│Thanos Query │──────────┘
│             │    │ (Global)    │
└─────────────┘    └─────────────┘
```

#### Thanos Features

- **Global View**: Query across multiple Prometheus instances
- **Minimal Changes**: Requires minimal changes to existing Prometheus setups
- **Downsampling**: Automatic data downsampling for long-term storage
- **Deduplication**: Automatic deduplication of metrics
- **Multi-Cloud**: Works across different cloud providers and on-premises

### VictoriaMetrics

**Origin**: Developed by VictoriaMetrics team, focused on performance and cost efficiency  
**Architecture**: Single binary or cluster mode with emphasis on resource efficiency  
**Repository**: [VictoriaMetrics/VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics) ⭐ 12k+ stars, 400+ contributors  
**CNCF Status**: Not a CNCF project (independent open-source)

#### VictoriaMetrics Components

**Single Binary Mode**:

- **All-in-One**: Complete solution in a single binary for smaller deployments
- **Embedded Storage**: Built-in time series database optimized for compression
- **HTTP API**: Prometheus-compatible API for seamless integration

**Cluster Mode**:

- **VMStorage**: Storage nodes handling data persistence and queries
- **VMInsert**: Ingestion nodes for distributing incoming metrics
- **VMSelect**: Query nodes for handling PromQL queries
- **VMAgent**: Lightweight agent for metrics collection and remote write
- **VMAlert**: Alerting component compatible with Prometheus rules

#### VictoriaMetrics Architecture

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prometheus  │───▶│  VMAgent    │───▶│  VMInsert   │
│ (Remote     │    │(Collection) │    │ (Ingestion) │
│  Write)     │    └─────────────┘    └─────────────┘
└─────────────┘                             │
                                            ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Grafana   │◀───│  VMSelect   │◀───│ VMStorage   │
│             │    │  (Query)    │    │(Persistence)│
└─────────────┘    └─────────────┘    └─────────────┘
```

#### VictoriaMetrics Features

- **High Performance**: Up to 20x better performance than Prometheus
- **Resource Efficiency**: Minimal CPU and memory usage
- **Superior Compression**: 10x better compression ratios than Prometheus
- **Prometheus Compatibility**: Drop-in replacement with full PromQL support
- **Multi-Tenancy**: Built-in tenant isolation in cluster mode
- **Downsampling**: Automatic data downsampling for long-term retention
- **Backfilling**: Support for importing historical data
- **Stream Aggregation**: Real-time metric aggregation capabilities

### GreptimeDB

**Origin**: Developed by Greptime team, modern cloud-native time series database  
**Architecture**: SQL-based time series database with storage/compute separation  
**Repository**: [GreptimeTeam/greptimedb](https://github.com/GreptimeTeam/greptimedb) ⭐ 4.2k+ stars, 300+ contributors  
**CNCF Status**: Not a CNCF project (independent open-source)

#### GreptimeDB Components

**Core Architecture**:

- **Frontend**: SQL query layer and protocol handlers (MySQL, PostgreSQL, PromQL)
- **Datanode**: Storage engine for time series data with advanced compression
- **Metanode**: Cluster metadata management and coordination
- **Object Storage**: S3-compatible storage backend for data persistence

**Deployment Modes**:

- **Standalone**: Single binary for development and small deployments
- **Cluster**: Distributed mode with separate frontend, datanode, and metanode
- **Cloud**: Managed service with automatic scaling and optimization

#### GreptimeDB Architecture

```text
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ Prometheus  │───▶│  Frontend   │───▶│  Datanode   │
│ (Remote     │    │ (PromQL)    │    │ (Storage)   │
│  Write)     │    └─────────────┘    └─────────────┘
└─────────────┘                             │
                                            ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Grafana   │◀───│  Frontend   │◀───│Object Storage│
│             │    │ (Query)     │    │ (S3/GCS)    │
└─────────────┘    └─────────────┘    └─────────────┘
```

#### GreptimeDB Features

- **SQL + PromQL**: Native SQL support with >90% PromQL compatibility
- **Exceptional Performance**: 5x more resource efficient than Mimir
- **Superior Compression**: Advanced compression algorithms for cost optimization
- **Elastic Scaling**: Independent scaling of storage and compute resources
- **Multi-Protocol**: MySQL, PostgreSQL, PromQL, and InfluxDB protocols
- **Cloud-Native**: Kubernetes-native with operator support
- **Time Travel**: Historical data queries with SQL temporal functions
- **Real-time Analytics**: Built-in stream processing capabilities

## Detailed Comparison

### Deployment Complexity

| Aspect | Mimir | Cortex | Thanos | VictoriaMetrics | GreptimeDB |
|--------|-------|--------|--------|----------------|------------|
| **Setup Complexity** | Medium | High | Low-Medium | Low | Low |
| **Operational Overhead** | Medium | High | Low | Very Low | Low |
| **Prometheus Changes** | Remote write only | Remote write only | Minimal (sidecar) | Remote write only | Remote write only |
| **Learning Curve** | Medium | High | Low-Medium | Low | Low-Medium |

### Scalability & Performance

| Feature | Mimir | Cortex | Thanos | VictoriaMetrics | GreptimeDB |
|---------|-------|--------|--------|----------------|------------|
| **Horizontal Scaling** | Excellent | Excellent | Good | Excellent | Excellent |
| **Query Performance** | High | High | Medium-High | Very High | Very High |
| **Ingestion Rate** | Very High | High | Medium | Exceptional | Exceptional |
| **Memory Efficiency** | Optimized | Good | Good | Exceptional | Exceptional |
| **Storage Efficiency** | High | High | Very High (downsampling) | Exceptional | Exceptional |

### Features & Capabilities

| Feature | Mimir | Cortex | Thanos | VictoriaMetrics | GreptimeDB |
|---------|-------|--------|--------|----------------|------------|
| **Multi-Tenancy** | ✅ Advanced | ✅ Advanced | ✅ Basic | ✅ Advanced | ✅ Advanced |
| **Global Querying** | ✅ | ✅ | ✅ Excellent | ✅ | ✅ |
| **Deduplication** | ✅ | ✅ | ✅ Advanced | ✅ | ✅ |
| **Downsampling** | ✅ | ✅ | ✅ Automatic | ✅ Automatic | ✅ Automatic |
| **Rule Evaluation** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Alerting** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Stream Processing** | ✅ | ❌ | ❌ | ✅ Advanced | ✅ Native |

### Storage & Retention

| Aspect | Mimir | Cortex | Thanos | VictoriaMetrics | GreptimeDB |
|--------|-------|--------|--------|----------------|------------|
| **Object Storage** | S3, GCS, Azure | S3, GCS, Azure, Swift | S3, GCS, Azure, Swift | S3, GCS, Azure, Local | S3, GCS, Azure |
| **Compression** | Excellent | Good | Excellent | Exceptional | Exceptional |
| **Retention Policies** | Flexible | Flexible | Flexible | Very Flexible | Very Flexible |
| **Block Management** | Advanced | Standard | Advanced | Optimized | Advanced |

## Use Case Recommendations

### Choose Mimir When

- **Modern Deployments**: Starting fresh or modernizing existing setups
- **High Performance Required**: Need maximum query and ingestion performance
- **Grafana Ecosystem**: Already using Grafana and want tight integration
- **Multi-Tenancy**: Require advanced tenant isolation and management
- **Real-time Analytics**: Need streaming query capabilities

**Ideal For**: SaaS platforms, multi-tenant environments, high-traffic applications

### Choose Cortex When

- **CNCF Compliance**: Need a graduated CNCF project for governance
- **Flexibility Required**: Need highly configurable deployment options
- **Mature Solution**: Want proven technology with extensive production use
- **Community Support**: Prefer established community and ecosystem
- **Hybrid Deployments**: Need to support various deployment patterns

**Ideal For**: Enterprise environments, regulated industries, complex multi-cloud setups

### Choose Thanos When

- **Existing Prometheus**: Want to extend current Prometheus deployments with minimal changes
- **Global Visibility**: Need to query across multiple clusters/regions
- **Cost Optimization**: Storage costs are a primary concern (excellent compression/downsampling)
- **Gradual Migration**: Want to incrementally adopt long-term storage
- **Multi-Cloud**: Operating across different cloud providers

**Ideal For**: Large-scale Kubernetes deployments, multi-cluster environments, cost-sensitive operations

### Choose VictoriaMetrics When

- **Resource Efficiency**: Need maximum performance with minimal resource usage
- **Cost Optimization**: Primary concern is reducing infrastructure costs
- **Simple Operations**: Want minimal operational complexity
- **High Performance**: Need exceptional ingestion and query performance
- **Prometheus Compatibility**: Require seamless migration from existing Prometheus setups
- **Single Binary Deployment**: Prefer simple deployment models

**Ideal For**: High-scale cost-conscious environments, resource-constrained deployments, performance-critical applications

### Choose GreptimeDB When

- **Modern Architecture**: Want a cloud-native, SQL-based time series database
- **Maximum Efficiency**: Need the best resource efficiency and cost optimization
- **Multi-Protocol Support**: Require SQL, PromQL, and other protocol compatibility
- **Advanced Analytics**: Want built-in SQL capabilities for complex queries
- **Elastic Scaling**: Need independent storage and compute scaling
- **Simplified Operations**: Prefer managed service options with minimal operational overhead

**Ideal For**: Modern cloud-native deployments, analytical workloads, cost-sensitive high-scale environments

## Operational Considerations

### Monitoring & Observability

All solutions provide comprehensive metrics for monitoring:

- **Ingestion Metrics**: Rate, errors, latency
- **Query Metrics**: Performance, cache hit rates
- **Storage Metrics**: Object storage operations, compaction status
- **Resource Metrics**: CPU, memory, disk usage per component

### Backup & Disaster Recovery

- **Object Storage**: Primary data durability mechanism
- **Multi-Region**: Configure object storage for cross-region replication
- **Metadata Backup**: Backup configuration and metadata regularly
- **Testing**: Regular disaster recovery testing procedures

### Security Considerations

- **Authentication**: Integration with existing identity providers
- **Authorization**: Role-based access control (RBAC)
- **Encryption**: Data encryption in transit and at rest
- **Network Security**: Proper network segmentation and policies
- **Secrets Management**: Secure handling of storage credentials

## Cost Analysis

### Infrastructure Costs

| Component | Mimir | Cortex | Thanos | VictoriaMetrics | GreptimeDB |
|-----------|-------|--------|--------|----------------|------------|
| **Compute** | High (microservices) | High (microservices) | Medium (fewer components) | Low (efficient) | Very Low (optimized) |
| **Storage** | Medium (efficient compression) | Medium | Low (excellent compression) | Very Low (superior compression) | Very Low (advanced compression) |
| **Network** | Medium | Medium | Low (query optimization) | Low (optimized protocols) | Low (efficient protocols) |

### Operational Costs

- **Mimir**: Lower operational overhead due to better defaults
- **Cortex**: Higher operational overhead due to configuration complexity
- **Thanos**: Lowest operational overhead for existing Prometheus users
- **VictoriaMetrics**: Minimal operational overhead with single binary option
- **GreptimeDB**: Very low operational overhead with cloud-native automation

## Conclusion

The choice between Mimir, Cortex, Thanos, VictoriaMetrics, and GreptimeDB depends on your specific requirements:

- **Mimir** offers the best performance and modern features for new deployments
- **Cortex** provides maximum flexibility and is ideal for complex enterprise requirements
- **Thanos** offers the easiest migration path and excellent global querying for existing Prometheus users
- **VictoriaMetrics** delivers exceptional resource efficiency and cost optimization with superior performance
- **GreptimeDB** provides modern SQL-based architecture with maximum efficiency and cloud-native automation

All five solutions successfully address Prometheus's long-term storage limitations, but the optimal choice depends on your organization's technical requirements, operational capabilities, performance needs, and cost constraints.

Consider starting with a proof-of-concept deployment to evaluate which solution best fits your specific use case and operational constraints.
