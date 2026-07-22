# Sync users from Active Directory

Keycloak can federate an external LDAP directory, so users defined in
Microsoft Active Directory (AD) are imported and kept in sync with a Keycloak
realm. This is done with an **LDAP User Storage Provider** (User Federation).

## How it works

- Keycloak connects to AD over LDAP/LDAPS using a service (bind) account.
- Matching users are imported into the realm database as local user copies.
- Authentication is delegated to AD, so passwords stay in AD.
- Mappers translate AD attributes (mail, sn, givenName, ...) into Keycloak
  user attributes. Keycloak creates a default set of mappers based on the
  selected *Vendor*, *Edit Mode* and *Import Users* options.

## Prerequisites

- An AD Domain Controller reachable from Keycloak (LDAP `389` / LDAPS `636`).
- A bind account (read access, or read/write if you plan to write back).
- For LDAPS, the AD CA certificate trusted by Keycloak.

## Key configuration values

When creating the provider (**Realm > User federation > Add LDAP providers**),
select **Vendor: `Active Directory`**. The most relevant settings are:

| Setting                 | Example / meaning                                         |
|-------------------------|-------------------------------------------------------------|
| Connection URL          | `ldaps://dc1.example.com:636` (prefer LDAPS)              |
| Bind type / Bind DN     | `simple` / `CN=svc-keycloak,OU=Service,DC=example,DC=com` |
| Bind credential         | service account password (use a Secret)                   |
| Users DN                | `CN=Users,DC=example,DC=com`                              |
| Username LDAP attribute | `sAMAccountName` (or `userPrincipalName`)                 |
| RDN LDAP attribute      | `cn`                                                      |
| UUID LDAP attribute     | `objectGUID`                                              |
| User object classes     | `person, organizationalPerson, user`                      |
| Edit mode               | `READ_ONLY`, `WRITABLE` or `UNSYNCED`                     |

!!! warning
    Decide **Edit Mode** and **Import Users** at creation time. Changing them
    later may not update the generated mappers correctly (especially in
    `UNSYNCED` mode).

## AD account state (MSAD mappers)

When Vendor is `Active Directory`, Keycloak creates two AD-specific mappers
that read AD control attributes so account state is honored:

- **MSAD account controls** mapper reads `userAccountControl` and `pwdLastSet`.
  Disabled, locked or expired AD accounts cannot log in, and users flagged to
  change their password at next logon are prompted accordingly.
- **MSAD LDS account controls** mapper does the same for AD LDS
  (Lightweight Directory Services) using `msDS-UserAccountDisabled` and
  `msDS-UserPasswordExpired`.

These are added automatically; no manual mapper setup is required for a
standard AD deployment.

## Synchronization

Two sync operations keep the realm aligned with AD:

- **Full sync**: imports all AD users and updates existing ones.
- **Changed users sync**: imports only users created/updated since the last
  sync.

Recommended flow: run one initial **full sync** after creating the provider,
then schedule **periodic sync of changed users**. Periods are set with:

- `Periodic full sync` → `fullSyncPeriod` (seconds, `-1` disables)
- `Periodic changed users sync` → `changedSyncPeriod` (seconds, `-1` disables)
- `batchSizeForSync` → users imported per LDAP query page (e.g. `1000`)

## Declarative creation (GitOps)

For a GitOps workflow, keep the provider definition in a realm export and load
it with realm import instead of clicking in the console. The equivalent
`kcadm` component for an AD provider looks like:

```bash
kcadm.sh create components -r myrealm \
  -s name=ad-provider \
  -s providerId=ldap \
  -s providerType=org.keycloak.storage.UserStorageProvider \
  -s 'config.vendor=["ad"]' \
  -s 'config.editMode=["READ_ONLY"]' \
  -s 'config.syncRegistrations=["false"]' \
  -s 'config.connectionUrl=["ldaps://dc1.example.com:636"]' \
  -s 'config.usersDn=["CN=Users,DC=example,DC=com"]' \
  -s 'config.authType=["simple"]' \
  -s 'config.bindDn=["CN=svc-keycloak,OU=Service,DC=example,DC=com"]' \
  -s 'config.bindCredential=["<your-secret-here>"]' \
  -s 'config.usernameLDAPAttribute=["sAMAccountName"]' \
  -s 'config.rdnLDAPAttribute=["cn"]' \
  -s 'config.uuidLDAPAttribute=["objectGUID"]' \
  -s 'config.userObjectClasses=["person, organizationalPerson, user"]' \
  -s 'config.fullSyncPeriod=["-1"]' \
  -s 'config.changedSyncPeriod=["86400"]' \
  -s 'config.batchSizeForSync=["1000"]' \
  -s 'config.pagination=["true"]' \
  -s 'config.useTruststoreSpi=["always"]'
```

## Links

- User federation: LDAP
<https://www.keycloak.org/docs/latest/server_admin/#_ldap>

- Synchronizing LDAP users to Keycloak
<https://www.keycloak.org/docs/latest/server_admin/#_ldap-sync>
