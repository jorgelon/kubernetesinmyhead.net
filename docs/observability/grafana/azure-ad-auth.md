# Autenticacion via Azure

## Creacion de la aplicacion

Creamos una nueva aplicacion desde App Registrations > New Registration

- Supported Account types:  
Por ejemplo "Accounts in this organizational directory only"
- Redirect URI  
En el asistente inicial, ponemos <https://migrafana.dominio.com>

## Postconfiguracion de la aplicacion

- Segunda Redirect URl  
En Manage - Authentication - Web - Redirect URls creamos una nueva con <https://migrafana.dominio.com/login/azuread>

- Client Secret  
En "Manage - Certificates & secrets - Client secrets" creamos un nuevo client secret y colocamos su valor en la variable GF_AUTH_AZUREAD_CLIENT_SECRET

- Groups claim  
En "Manage - Token Configuration" agregamos un groups claim seleccionando "security groups "y "Groups assigned to the application"

- Api permissions  
Deberiamos tener Microsoft Graph - User.Read

- App Roles
Creamos 3 roles con el mismo valor Display Name, Value y Description y eligiendo "Users/Groups" como "Allowed member types".
Ese valor sera Viewer, Editor y GrafanaAdmin

- Agregar grupos
Desde Enterprise Applications entramos en nuestra aplicacion y en Manage - Users and groups elegimos los grupos y usuarios que queremos y los mapemos a los roles deseados

## Lista de variables de entorno

### Autenticacion

```txt
GF_AUTH_AZUREAD_AUTH_URL: valor que figura como "OAuth 2.0 authorization endpoint (v2)" en "Endpoints"
GF_AUTH_AZUREAD_TOKEN_URL: valor que figura como "OAuth 2.0 token endpoint (v2)" en "Endpoints"
GF_AUTH_AZUREAD_CLIENT_ID: valor que figura como "Application (client) ID" en Overview
GF_AUTH_AZUREAD_CLIENT_SECRET: valor del secret creado anteriormente

```

## Usuarios y asignacion de roles

Si no hay definido ningun rol en la aplicacion, el valor asignado sera el indicado en GF_USERS_AUTO_ASSIGN_ORG_ROLE.
Este valor por defecto es Viewer y tambien puede ser Admin, Editor y None.

Este funcionamiento de asignar un rol por defecto puede quitarse poniendo a true GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT, lo que no permite el login si no hay un rol definido para el usuario.

| Variable                              | Valor raz. | Funcion                                                                              |
|---------------------------------------|------------|--------------------------------------------------------------------------------------|
| GF_USERS_AUTO_ASSIGN_ORG_ROLE         | Viewer     | permite definir el rol predeterminado para los usuarios de la organizacion principal |
| GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT |            | deshabilita la asignacion de un rol por defecto                                      |
| GF_AUTH_AZUREAD_SKIP_ORG_ROLE_SYNC    |            | evita traerse los roles del Azure.                                                   |

Puede ser una buena practica habilitar GF_AUTH_AZUREAD_ROLE_ATTRIBUTE_STRICT, lo que fuerza a crear roles de aplicacion

### Misc

| Variable                                   | Valor raz.             | Funcion                                                               |
|--------------------------------------------|------------------------|-----------------------------------------------------------------------|
| GF_AUTH_AZUREAD_ALLOW_ASSIGN_GRAFANA_ADMIN | false                  | Deshabilita al rol GrafanaAdmin el tener privilegios de administrador |
| GF_AUTH_AZUREAD_ALLOW_SIGN_UP              | true                   |                                                                       |
| GF_AUTH_AZUREAD_AUTO_LOGIN                 | false                  | Habilitarlo se salta la pantalla de login                             |
| GF_AUTH_AZUREAD_ENABLED                    | true                   | Habilita Azure ad Auth                                                |
| GF_AUTH_AZUREAD_NAME                       | "Azure AD"             | Nombre de la configuracion                                            |
| GF_AUTH_AZUREAD_SCOPES                     | "openid email profile" |                                                                       |
| GF_AUTH_AZUREAD_USE_PKCE                   | true                   |                                                                       |
| GF_AUTH_AZUREAD_ALLOWED_ORGANIZATIONS      |                        | identificador de la organizacion que queremos permitir el acceso      |
| GF_AUTH_AZUREAD_ALLOWED_GROUPS             |                        | grupos que permitimos el acceso separado por comas o espacios de i    |
| GF_AUTH_AZUREAD_ALLOWED_DOMAIN             |                        | dominios que permitmos el acceso separado por comas o espacios        |

## Links

- Configure Azure AD OAuth2 authentication  
<https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/azuread/>

- Configure Grafana  
<https://grafana.com/docs/grafana/latest/setup-grafana/configure-grafana/>
