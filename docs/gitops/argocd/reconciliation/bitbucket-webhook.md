# Bitbucket Server (self-hosted) webhook

Configure ArgoCD to refresh on push events received from a self-hosted Bitbucket Server repository.
This is useful when increasing or disabling `timeout.reconciliation`.

## Bitbucket Server side

Go to your repository in **Repository Settings > Webhooks** and click **Create webhook**.

```txt
Name:   ArgoCD webhook (or any name)
URL:    https://YOUR_ARGOCD_INSTANCE_URL/api/webhook  (must be reachable from Bitbucket Server)
Secret: use a password generator to define a token
Events: Repository > Push
Active: enabled
```

Save the webhook. Bitbucket Server will start sending a `POST` with an `X-Hub-Signature` header
signed with the secret on every push event.

> Bitbucket Server must have network connectivity to the ArgoCD instance.
> If ArgoCD is only exposed internally, the webhook URL can be an internal ingress or the
> cluster-internal address (e.g. `http://argocd-server.argocd.svc.cluster.local/api/webhook`).

## Branch filtering

Unlike GitLab, **Bitbucket Server webhooks do not support branch filtering at the webhook
configuration level**. There is no field to restrict which branches trigger the hook.

Branch matching is handled entirely by ArgoCD: when a push event arrives, ArgoCD compares the
ref in the payload against each application's `targetRevision`. Only applications whose
`targetRevision` matches the pushed branch (or `HEAD` for the default branch) are refreshed.

## Bitbucket Cloud vs Bitbucket Server

These are two separate integrations in ArgoCD with different secret mechanisms:

|                              | Bitbucket Cloud                   | Bitbucket Server                 |
|------------------------------|-----------------------------------|----------------------------------|
| ArgoCD secret key            | `webhook.bitbucket.uuid`          | `webhook.bitbucketserver.secret` |
| Verification                 | UUID token (`X-Hook-UUID` header) | HMAC shared secret               |
| Changed files in payload     | No (fetched via API callback)     | No (unavailable)                 |
| `manifest-generate-paths`    | Partially (via API)               | Not supported                    |

Do not mix them up when configuring `argocd-secret`.

## manifest-generate-paths annotation

The `argocd.argoproj.io/manifest-generate-paths` annotation is a monorepo optimization.
It tells ArgoCD which paths must have changed to trigger manifest regeneration — if no changed
files match the annotation, reconciliation is skipped entirely.

```yaml
metadata:
  annotations:
    argocd.argoproj.io/manifest-generate-paths: /my-app
```

**For this to work, ArgoCD needs the list of changed files from the webhook payload.**

- **Bitbucket Server**: the push payload does **not** include changed files and there is no
  API callback mechanism to retrieve them. The annotation is **ignored** — every push triggers
  reconciliation regardless of which paths changed.

- **Bitbucket Cloud**: the payload also omits changed files, but ArgoCD makes an API callback
  to Bitbucket's diffstat API to retrieve them. The annotation can work, but it depends on
  ArgoCD being able to reach the Bitbucket Cloud API.

Providers with native changed-file support in the payload (and full annotation support):
GitHub, GitLab, and Gogs.

## Links

- Git Webhook Configuration

<https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/>
