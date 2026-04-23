# Open-Source Self-Hosted Secret Sharing Tools

Solutions for securely sharing sensitive information via one-time or time-limited links. None of these tools are currently part of the CNCF ecosystem.

> **Note:** This document was created on 2026-04-23. Stars, contributors, and release information reflect data gathered at that date.

## Comparison Table

| Tool                              |  Stars | Contributors | Kubernetes Support        | CNCF |
|-----------------------------------|-------:|-------------:|---------------------------|------|
| [PrivateBin](#privatebin)         |  8,224 |          173 | Official Helm chart       | No   |
| [PasswordPusher](#passwordpusher) |  2,980 |           62 | Official Helm + manifests | No   |
| [OneTimeSecret](#onetimesecret)   |  2,767 |           19 | Official Helm chart (OCI) | No   |
| [Yopass](#yopass)                 |  2,736 |           79 | Official K8s manifest     | No   |
| [Snappass](#snappass)             |    896 |           43 | Community Helm only       | No   |
| [OTS (Luzifer)](#ots-luzifer)     |    752 |           27 | Community Helm only       | No   |
| [Vaultwarden](#vaultwarden)       | 58,772 |          183 | Community Helm only       | No   |
| [Shhh](#shhh)                     |    414 |            6 | None                      | No   |
| [Infisical](#infisical) ¹         | 26,200 |          228 | Official Helm chart       | No   |

> ¹ Infisical is a full secrets manager. Secret sharing is one of its features, not its primary purpose.

---

## PrivateBin

**Repository:** <https://github.com/PrivateBin/PrivateBin>

PHP-based zero-knowledge pastebin. Client-side AES-256-GCM encryption — the server never sees plaintext. Supports file attachments and optional password protection.

**Kubernetes:** Official Helm chart by the PrivateBin organization: <https://github.com/PrivateBin/helm-chart> (`https://privatebin.github.io/helm-chart/`)

---

## PasswordPusher

**Repository:** <https://github.com/pglombardo/PasswordPusher>

Ruby on Rails app. Supports expiry by views and/or time. Features audit logs, MFA, and 31 UI languages. Most actively released tool in this list.

**Kubernetes:** Official K8s manifests in `containers/kubernetes/` and official Helm chart in `containers/helm/` within the main repo.
Docs: <https://docs.pwpush.com/docs/installation/>

---

## OneTimeSecret

**Repository:** <https://github.com/onetimesecret/onetimesecret>

Ruby-based, the original one-time-secret tool. Redis backend. v0.25 (RC) adds organizations and SSO support.

**Kubernetes:** Official Helm chart via OCI from the onetimesecret organization at <https://github.com/onetimesecret/helm-chart>

```shell
helm install onetimesecret oci://ghcr.io/onetimesecret/helm-chart/onetimesecret
```

---

## Yopass

**Repository:** <https://github.com/jhaals/yopass>

Go-based, end-to-end encrypted in the browser using AES-256. One-time links with time-limited expiration. Memcached or Redis backend. The encryption key is embedded in the URL fragment and never sent to the server.

**Kubernetes:** Official K8s manifest at `deploy/yopass-k8.yaml` in the repo. Several community Helm charts available on ArtifactHub.

---

## Snappass

**Repository:** <https://github.com/pinterest/snappass>

Python/Flask-based. Fernet symmetric encryption. Redis backend. Developed by Pinterest. Low release frequency.

**Kubernetes:** No official chart. Community charts available: `lmacka/helm-snappass` (most complete, includes Valkey/Redis, HPA, Ingress) and `appuio/snappass` on ArtifactHub.

---

## OTS (Luzifer)

**Repository:** <https://github.com/Luzifer/ots>

Go-based. Browser-side AES-256 encryption — server never sees plaintext. The encryption key is in the URL fragment only. In-memory or Redis backend. Public hosted instance at <https://ots.fyi>. Very active release cadence.

**Kubernetes:** Community Helm chart via OCI at `ghcr.io/continuoussecuritytooling/ots-helm-chart` and on ArtifactHub (`m13t/ots`).

---

## Vaultwarden

**Repository:** <https://github.com/dani-garcia/vaultwarden>

Rust-based lightweight reimplementation of the Bitwarden server API. Bitwarden Send provides time-limited encrypted sharing links, the feature most comparable to Yopass. Single container, ~50 MB RAM. By far the most starred project in this list, but it is a full vault — not a purpose-built secret-sharing tool.

**Kubernetes:** No official chart. Community charts: `guerzon/vaultwarden` (most widely used) and `gabe565/vaultwarden` (OCI-based).

---

## Shhh

**Repository:** <https://github.com/smallwat3r/shhh>

Python/Flask-based. Fernet encryption with random salt and 100,000 PBKDF2 iterations. Single-author project, low activity. The maintainer has noted this project is being sunset in favor of a new project called `secretapi`.

**Kubernetes:** No Helm chart or manifests. Docker Compose only.

---

## Infisical

> **Note:** Infisical is a full-featured secrets manager. Secret sharing is one of its features, not its primary purpose.

**Repository:** <https://github.com/Infisical/infisical>

Generates an end-to-end encrypted public browser link. No Infisical account required for the recipient. Supports time-based expiration, configurable view-count limit (including single-use), and optional password protection. Works fully in self-hosted deployments. Docs: <https://infisical.com/docs/documentation/platform/secret-sharing>

**CNCF:** CNCF Silver Member (corporate membership, not a hosted project).

**Kubernetes:** Official Helm chart at `https://dl.cloudsmith.io/public/infisical/helm-charts/helm/charts/`. Also provides a Secrets Operator Helm chart for Kubernetes-native secret sync.
