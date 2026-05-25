# Grafana Public Dashboards

Public dashboards allow unauthenticated users to view specific Grafana dashboards
without requiring login credentials. This is achieved through two mechanisms:
anonymous authentication and embedding support.

## How It Works

Grafana exposes dashboards publicly by combining:

- **Anonymous auth**: Grafana accepts requests without a session, assigning them
  to a designated organization with a fixed role.
- **Embedding**: Grafana allows its UI to be rendered inside an `<iframe>` in
  external web pages.

## Required Configuration

The following environment variables must be set in the Grafana configuration:

| Variable                      | Value          | Purpose                             |
|-------------------------------|----------------|-------------------------------------|
| `GF_AUTH_ANONYMOUS_ENABLED`   | `"true"`       | Enables unauthenticated access      |
| `GF_AUTH_ANONYMOUS_ORG_NAME`  | `"<org name>"` | Organization for anonymous users    |
| `GF_AUTH_ANONYMOUS_ORG_ROLE`  | `Viewer`       | Role assigned to anonymous users    |
| `GF_SECURITY_ALLOW_EMBEDDING` | `"true"`       | Allows embedding Grafana in iframes |

These variables are typically delivered via a Kubernetes ConfigMap and mounted
as environment variables into the Grafana pod.

## Organization Setup

The organization referenced by `GF_AUTH_ANONYMOUS_ORG_NAME` must exist in
Grafana before anonymous access works. Steps:

1. Log in as a Grafana admin.
2. Go to **Administration > Organizations**.
3. Create the organization with the exact name matching the variable value.
4. Assign the desired dashboards and data sources to that organization.

Anonymous users will only see the resources belonging to this organization.

## Sharing a Public Dashboard

To share a specific dashboard publicly:

1. Open the dashboard in Grafana.
2. Click **Share** (top toolbar).
3. Select the **Public dashboard** tab.
4. Toggle **Enable public access** and confirm.
5. Copy the generated public URL.

The public URL does not require authentication and is safe to share externally
or embed in a portal.

### Public dashboard limitations

Grafana's built-in public dashboard feature has significant restrictions:

- **Template variables are not supported.** Dashboards that use variables will
  show errors on all panels that depend on them.
- Frontend data sources (TestData, etc.) fail to fetch data.
- Grafana Live and real-time event streams are not supported.
- Exemplars are omitted from query results.
- Only specific annotation types are supported.

For dashboards that use template variables, use the **anonymous auth approach**
with a regular dashboard URL and `?kiosk` instead.

## Embedding in an iframe

Once `GF_SECURITY_ALLOW_EMBEDDING` is enabled, use the dashboard URL or the
public dashboard URL inside an `<iframe>`:

```html
<iframe
  src="https://grafana.example.com/d/<dashboard-uid>/<slug>?orgId=1&kiosk"
  width="100%"
  height="600"
  frameborder="0">
</iframe>
```

The `kiosk` query parameter hides the Grafana navigation bar and side menu. As of
Grafana v11.3, dashboard controls (time range picker, variables, refresh button)
are shown by default even in kiosk mode. To hide them individually, append:

| Parameter                   | Hides                                |
|-----------------------------|--------------------------------------|
| `_dash.hideTimePicker=true` | Time range picker and refresh button |
| `_dash.hideVariables=true`  | Template variable dropdowns          |
| `_dash.hideLinks=true`      | Dashboard links                      |

Example URL hiding all controls:

```txt
https://grafana.example.com/d/<uid>/<slug>?kiosk&_dash.hideTimePicker=true&_dash.hideVariables=true
```

## Security Considerations

- Anonymous access is scoped to the configured organization only. Dashboards
  in other organizations remain protected.
- Grant the anonymous organization access only to non-sensitive dashboards and
  read-only data sources.
- Avoid assigning roles higher than `Viewer` to anonymous users.
- If embedding is not needed, leave `GF_SECURITY_ALLOW_EMBEDDING` unset or
  set to `"false"`.

## Links

- Grafana anonymous authentication:
  <https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/grafana/#anonymous-authentication>
- Grafana public dashboards:
  <https://grafana.com/docs/grafana/latest/dashboards/share-dashboards-panels/shared-dashboards/>
- Configure Grafana:
  <https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/>
