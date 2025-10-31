# Discovery

This represents how the adapter should find all Prometheus metrics for this rule. The discovery is done via the seriesQuery and seriesFilters fields

- seriesQuery

seriesQuery is a prometheus series query passed to the /api/v1/series prometheus endpoint  to find a sef of prometheus series.

- seriesFilters

seriesFilters can help us to add additional filters if it is necessary. We can use here "is: regex" or "isNot: regex"
