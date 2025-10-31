# Querying

## metricsQuery field

This field is a Go template that will be a Prometheus query and we can use this variables

- Series

It is the metric name

- LabelMatchers:

A comma-separated list of label matchers matching the given objects. Currently, this is the label for the particular group-resource, plus the label for namespace, if the group-resource is namespaced.

- GroupBy

A comma-separated list of labels to group by. Currently, this contains the group-resource label used in LabelMatchers.

> There are other advanced and less used variables: LabelValuesByName and GroupBySlice

## seriesQuery field

## resources field

## seriesFilters
