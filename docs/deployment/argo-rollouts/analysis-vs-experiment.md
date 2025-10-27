# Analysis vs Experiment

Argo Rollouts provides two mechanisms for validating deployments through metrics and progressive delivery: **Analysis** and **Experiment**. Understanding the differences between them is crucial for selecting the right approach for your deployment strategy.

## Quick Comparison

| Aspect            | Analysis                                                            | Experiment                                                      |
|-------------------|---------------------------------------------------------------------|-----------------------------------------------------------------|
| **Purpose**       | Evaluate metrics to make pass/fail decisions on rollout progression | Run concurrent variants (baseline + canary) to compare behavior |
| **Scope**         | Integrated into Rollout strategy steps                              | Standalone Kubernetes resource                                  |
| **Pod Creation**  | Uses existing rollout replicas                                      | Creates actual pods for baseline and canary variants            |
| **Duration**      | Runs at specific points (inline, background, pre/post-promotion)    | Limited timeframe (e.g., 1h)                                    |
| **Comparison**    | Single variant analysis                                             | Side-by-side comparison of two variants                         |
| **Analysis Type** | Basic metric validation                                             | Statistical comparison (e.g., Mann-Whitney, Kayenta)            |
| **Lifecycle**     | Tied to rollout progression                                         | Independent lifecycle                                           |

## Analysis

### What is an Analysis?

An `Analysis` evaluates metrics over time to determine if a rollout should proceed, pause, or rollback. It's integrated directly into the Rollout's deployment strategy and uses the existing application replicas being rolled out.

### Key Characteristics

- **Metric-driven decisions**: Evaluates success/failure conditions based on metrics from providers (Prometheus, Datadog, etc.)
- **Multiple timing options**:
  - **Inline**: Blocks rollout progression until analysis completes
  - **Background**: Runs concurrently with rollout steps
  - **Pre/Post-promotion**: For BlueGreen deployments, validates before or after traffic switch
- **Non-disruptive**: Works with your existing rollout replicas
- **Lightweight**: Focuses on metric queries, not pod creation

### Analysis Resources

- **AnalysisTemplate**: Reusable template defining metrics and conditions (namespace-scoped)
- **ClusterAnalysisTemplate**: Cluster-scoped version for sharing across namespaces
- **AnalysisRun**: Generated instance when analysis executes

### Example Use Cases

- Validate success rate during canary rollout
- Check error rates meet thresholds
- Verify response times are acceptable
- Run smoke tests before promotion (BlueGreen)

## Experiment

### What is an Experiment?

An `Experiment` creates a temporary, controlled environment where two versions of an application (baseline and canary) run concurrently for a limited duration. It generates actual pods and compares their metrics using analysis templates to determine which version performs better.

### Key Characteristics

- **Pod-based comparison**: Spins up replicas for both baseline and canary versions
- **Fixed duration**: Runs for a specified time window then terminates
- **Standalone resource**: Independent Kubernetes object, not embedded in Rollout
- **Statistical analysis**: Typically uses advanced comparison methods (Mann-Whitney, Kayenta)
- **Isolated testing**: Creates a separate environment without affecting production traffic
- **Comprehensive validation**: Compares both versions side-by-side before promoting

### Experiment Resources

- **Experiment**: Kubernetes CRD defining baseline template, canary template, duration, and analysis
- **Analysis templates**: Referenced for comparing the two variants

### Example Use Cases

- Compare v1 and v2 statistically before production rollout
- Run A/B tests in a controlled environment
- Validate major version upgrades with Kayenta analysis
- Measure performance differences before committing to rollout

## When to Use Each

### Use Analysis When

✅ You need lightweight metric validation
✅ You're checking success rates, error rates, latency
✅ You want to validate using existing rollout replicas
✅ You need quick pass/fail decisions
✅ You're doing canary or BlueGreen gradual progression
✅ You want to integrate validation into your deployment steps

### Use Experiment When

✅ You need statistical comparison between two versions
✅ You want to run A/B testing in isolation
✅ You're comparing major version changes
✅ You need Kayenta/Mann-Whitney statistical analysis
✅ You want to validate without affecting production traffic
✅ You prefer a controlled environment before production rollout

## Combined Usage

You can use both together in a staged approach:

1. **Pre-production validation** via Experiment (statistical comparison in isolated environment)
2. **Production validation** via Analysis (metric-driven checks during gradual rollout)

This pattern allows you to validate changes comprehensively before committing to production traffic.

## Key Metrics

Both Analysis and Experiment support multiple metric providers:

- **Prometheus**: Query-based metrics
- **Datadog**: APM and metrics
- **New Relic**: Application performance
- **Kayenta**: Statistical analysis framework
- **CloudWatch**: AWS metrics
- **Wavefront**: Time-series data
- **Custom**: Webhook-based metrics
