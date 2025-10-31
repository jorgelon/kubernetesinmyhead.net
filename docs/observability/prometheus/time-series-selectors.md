# Time series selectors

These are the basic building-blocks that instruct PromQL what data to fetch.

## Range Vector Selectors

Range vector literals work like instant vector literals, except that they select a range of samples back from the current instant. Syntactically, a float literal is appended in square brackets ([]) at the end of a vector selector to specify for how many seconds back in time values should be fetched for each resulting range vector element. Commonly, the float literal uses the syntax with one or more time units, e.g. [5m]. The range is a left-open and right-closed interval, i.e. samples with timestamps coinciding with the left boundary of the range are excluded from the selection, while samples coinciding with the right boundary of the range are included in the selection.

In this example, we select all the values recorded less than 5m ago for all time series that have the metric name http_requests_total and a job label set to prometheus:

http_requests_total{job="prometheus"}[5m]
