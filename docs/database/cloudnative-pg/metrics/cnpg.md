# CNPG metrics

## cnpg_backends_total

This metric total tracks how many client connections (backend) are in a PostgreSQL database instance managed by CloudNative-PG. This includes the active, idle, idle in trasaction and other connection states

It's derived from PostgreSQL's internal connection tracking and is essential for monitoring database connection health and It's equivalent to SELECT count(*) FROM pg_stat_activity, which counts all entries in   the activity table regardless of state.

## cnpg_backends_waiting_total

Counts the total number of backend connections that are waiting (measured in seconds).

The metric helps identify when PostgreSQL backends are stuck waiting for resources or query completion, which can indicate database performance problems.
