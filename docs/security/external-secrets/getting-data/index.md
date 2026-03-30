# Getting data from the provider

An ExternalSecret fetches secrets from an external provider and stores them as
a Kubernetes Secret. There are two ways to specify which data to fetch:

- **`spec.data`** — fetch individual keys explicitly, one mapping per entry
- **`spec.dataFrom`** — fetch multiple keys at once, with optional filtering
  and rewriting

Both fields are optional per the CRD spec, but at least one must be present for
the ExternalSecret to produce any data. They can be combined — when both are
used, keys are merged in order.

## Comparison

|                   | `spec.data`             | `spec.dataFrom`                     |
|-------------------|-------------------------|-------------------------------------|
| Required by CRD   | No                      | No                                  |
| Key selection     | Explicit, one per entry | All keys or filtered (extract/find) |
| Granularity       | Per-key                 | Bulk                                |
| Key renaming      | Via `secretKey`         | Via `rewrite`                       |
| Generator support | No                      | Yes (via `sourceRef.generatorRef`)  |
| Use case          | Fine-grained control    | Sync many keys at once              |

## Links

- [spec.data](data.md)
- [spec.dataFrom](datafrom.md)
- ExternalSecret API spec: <https://external-secrets.io/latest/api/spec>
