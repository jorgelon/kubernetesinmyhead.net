# HelmChart

A helm chart downloads a helm chart and packages as a tarball

## Configuration

## Source

- We can define the source of the chart with spec.sourceRef
- The chart name or path of the sourceRef (spec, chart)
- The list of value files, as a relative path in the sourceRef (spec.valuesFiles)
- If some declared value files don't exist, we can ignore the error (spec.ignoreMissingValuesFiles)

If the sourceRef is a HelmRepository

- The version (spec.version)

## Operations

- The frequency to check the spec.sourceRef for updates (spec.interval)
- If we want to create a new version with a new ChartVersion or Revision (spec.reconcileStrategy)

for a HelmRepository, it will be ChartVersion
for a GitRepository or bucket, it will be Revision

- If we want to suspend the reconciliation (spec.suspend)
- If we want to verify the chart (spec.verify)

More info here

<https://fluxcd.io/flux/components/source/helmcharts/>

And the spec here

<https://fluxcd.io/flux/components/source/api/v1/#source.toolkit.fluxcd.io/v1.HelmChart>
