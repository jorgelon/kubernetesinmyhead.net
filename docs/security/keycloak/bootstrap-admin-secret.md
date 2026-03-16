# Bootstrap admin secret

## What is it

When a `Keycloak` CR is created and no `spec.bootstrapAdmin` is configured, the
Keycloak operator automatically generates a Kubernetes Secret named
`<keycloak-cr-name>-initial-admin` in the same namespace.

It contains a temporary admin account with:

- `username`: `temp-admin`
- `password`: auto-generated random value

This is the only mechanism to access the admin console on a fresh install.

## Lifecycle

The secret is a **dependent resource** managed by the operator. This means:

- The operator **will recreate it** on the next reconciliation loop if deleted.
- It is only useful during the **first boot**, when the master realm
  does not yet exist.
- Once the master realm exists, the bootstrap credentials are
  **no longer accepted** by Keycloak itself.

## Retrieving the credentials

```bash
kubectl get secret <keycloak-cr-name>-initial-admin \
  -o jsonpath='{.data.username}' | base64 --decode

kubectl get secret <keycloak-cr-name>-initial-admin \
  -o jsonpath='{.data.password}' | base64 --decode
```

## Is it safe to delete it

Yes, once the initial setup is done the secret is no longer functional.
However, since the operator reconciles it, deleting it alone is not enough.

The proper approach is:

1. Log in to the admin console using `temp-admin` and the generated password.
2. Create a permanent admin user with a strong password.
3. **Delete the `temp-admin` user** from the master realm in the admin console.
4. Configure `spec.bootstrapAdmin` in the `Keycloak` CR to point to your own
   managed secret. This prevents the operator from auto-generating the
   `-initial-admin` secret on reconciliation.

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  bootstrapAdmin:
    user:
      secret: my-admin-secret   # must contain 'username' and 'password' keys
```

Keeping the secret around with a live `temp-admin` user is the actual security
risk, not the secret itself.

## Changing admin credentials

Updating the secret values referenced by `spec.bootstrapAdmin` (or the
auto-generated `-initial-admin` secret) **does not change** the admin user or
password in Keycloak.

The bootstrap credentials are **one-shot**: Keycloak only reads them when the
master realm is being created for the first time. The internal API confirms
this — the admin user is created only if no other users exist in the master
realm. Once the master realm exists, Keycloak **ignores the bootstrap secret
entirely** on every subsequent startup.

### Recovery use case (Keycloak 26+)

Since Keycloak 26, the bootstrap mechanism can also be used to **recover access**
if all admin users are locked out. This is a deliberate manual procedure, not
an automatic sync.

### How to actually change admin credentials

Use one of these methods:

- Admin console: Users → select user → Credentials tab → Reset password
- Admin CLI:

```bash
kcadm.sh set-password -r master --username <admin-user> \
  --new-password <new-password>
```

- REST API: `PUT /admin/realms/master/users/{id}/reset-password`

The Kubernetes secret is **not** a live source of truth for Keycloak user
credentials.

## Links

- Basic deployment
  <https://www.keycloak.org/operator/basic-deployment>

- Advanced configuration (bootstrapAdmin)
  <https://www.keycloak.org/operator/advanced-configuration>

- Bootstrap admin and recovery guide
  <https://www.keycloak.org/server/bootstrap-admin-recovery>
