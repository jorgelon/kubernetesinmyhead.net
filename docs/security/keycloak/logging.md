# Keycloak logging

Two ways to setup a more verbose loggin using the keycloak operator

## Keycloak logging handler

We can choose between these handlers: console (default), file, syslog and gelf

Also we can use the environment variable KC_LOG

We to change the fields of the template used by the logging system

- using the console handler: --log-console-format and KC_LOG_CONSOLE_FORMAT
- using the file handler: --log-file-format and KC_LOG_FILE_FORMAT

Another options are:

- Change the output to json instead of plain
- Enable color logging using the console handler

## Keycloak logging level

To enable a more verbose logging we can use the "--log-level" parameter and choose between several log levels: FATAL, ERROR, WARN, INFO, DEBUG, TRACE, ALL, OFF. The error level can be in lowercase or uppercase.

Also we can use the environment variable KC_LOG_LEVEL

It is possible to setup a different log level to the default (root) per category, with this format:

```txt
--log-level="<root-level>,<org.category1>:<org.category1-level>"
```

## Hostname debug

For debugging hostname related problems, we can enable a debug feature using --hostname-debug=true
Also we can use the environment variable KC_HOSTNAME_DEBUG

After enabling it, we can access to MYKEYCLOAKURL/realms/master/hostname-debug to see some hostname information

## Example in the keycloak operator

```yaml
apiVersion: k8s.keycloak.org/v2alpha1
kind: Keycloak
metadata:
  name: keycloak
spec:
  additionalOptions:
    - name: hostname-debug
      value: "true"
    - name: log-level
      value: DEBUG
```

## Links

- Configure logging  
<https://www.keycloak.org/server/logging>

- Logging settings  
<https://www.keycloak.org/server/all-config#category-logging>

- Hostname troubleshooting  
<https://www.keycloak.org/server/hostname#_troubleshooting>

- Admin console not loading and hostname related issues #14666  
<https://github.com/keycloak/keycloak/issues/14666>
