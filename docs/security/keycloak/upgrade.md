# Upgrade keycloak

## How to upgrade keycloaks from minor releases

- Review the migration changes to the new minor release

- Shutdown keycloak

- Backup the database

> A threshold of 300000 records exists for automatic migration

## Upgrade to keycloak

<https://www.keycloak.org/2024/06/keycloak-2500-released>

### Upgrade the Keycloak server

#### Upgrade the Keycloak adapters

Upgrade the Keycloak Client Libraries (Admin client, Authorization client, Policy enforcer). These are released independently of the Keycloak server and could be typically updated independently of the Keycloak server as the last released version of the client libraries should be compatible with the last released version of the Keycloak server. For more information, see the Upgrading Keycloak Client libraries.
Update the server

## From keycloak 25 to 26

<https://www.keycloak.org/docs/26.2.5/upgrading/>
<https://www.keycloak.org/operator/advanced-configuration>
<https://www.keycloak.org/operator/basic-deployment>
<https://www.keycloak.org/operator/rolling-updates>
<https://www.keycloak.org/server/containers>
<https://www.keycloak.org/server/hostname>
<https://www.keycloak.org/2024/03/keycloak-2400-released>
<https://www.keycloak.org/server/all-config>

hostname v1

The Keycloak Operator has removed the hostname v1 feature, which was deprecated in Keycloak 25 and replaced by hostname v2. If you are using hostname v1, you must migrate to hostname v2. This includes updating your configuration files and Keycloak Operator Custom Resources.

## Links

<https://www.keycloak.org/docs/latest/upgrading/>
<https://www.keycloak.org/docs/latest/release_notes/>
<https://www.keycloak.org/blog-archive>
<https://www.keycloak.org/2024/06/keycloak-2500-released>

hostname v1

The Keycloak Operator has removed the hostname v1 feature, which was deprecated in Keycloak 25 and replaced by hostname v2. If you are using hostname v1, you must migrate to hostname v2. This includes updating your configuration files and Keycloak Operator Custom Resources.
