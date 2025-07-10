# Settings table

## List of argocd settings

```txt
AppC = application controller
Server = argocd server
AppSC = applicationset controller
Repo = repo server
```

| Variable                                                         | Setting in the configmap                   | configmap            | AppC | Server | AppSC | Repo |
|------------------------------------------------------------------|--------------------------------------------|----------------------|------|--------|-------|------|
| REDIS_PASSWORD                                                   |                                            | argocd-redis         | x    | x      |       | x    |
| ARGOCD_CONTROLLER_REPLICAS                                       |                                            | hardcoded            | x    |        |       |      |
| ARGOCD_RECONCILIATION_TIMEOUT                                    | timeout.reconciliation                     | argocd-cm            | x    |        |       | x    |
| ARGOCD_HARD_RECONCILIATION_TIMEOUT                               | timeout.hard.reconciliation                | argocd-cm            | x    |        |       |      |
| ARGOCD_RECONCILIATION_JITTER                                     | timeout.reconciliation.jitter              | argocd-cm            | x    |        |       |      |
| ARGOCD_REPO_ERROR_GRACE_PERIOD_SECONDS                           | controller.repo.error.grace.period.seconds | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER                        |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_TIMEOUT_SECONDS        |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_STATUS_PROCESSORS                  |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_OPERATION_PROCESSORS               |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_LOGFORMAT                          |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_LOGLEVEL                           |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_METRICS_CACHE_EXPIRATION           |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_TIMEOUT_SECONDS          |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_TIMEOUT_SECONDS  |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_FACTOR           |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_CAP_SECONDS      |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SELF_HEAL_BACKOFF_COOLDOWN_SECONDS |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SYNC_TIMEOUT                       |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_PLAINTEXT              |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_REPO_SERVER_STRICT_TLS             |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_PERSIST_RESOURCE_HEALTH            |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APP_STATE_CACHE_EXPIRATION                                |                                            | argocd-cmd-params-cm | x    |        |       |      |
| REDIS_SERVER                                                     |                                            | argocd-cmd-params-cm | x    | x      |       | x    |
| REDIS_COMPRESSION                                                |                                            | argocd-cmd-params-cm | x    | x      |       | x    |
| REDISDB                                                          |                                            | argocd-cmd-params-cm | x    | x      |       | x    |
| ARGOCD_DEFAULT_CACHE_EXPIRATION                                  |                                            | argocd-cmd-params-cm | x    | x      |       | x    |
| ARGOCD_APPLICATION_CONTROLLER_OTLP_ADDRESS                       |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_OTLP_INSECURE                      |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_OTLP_HEADERS                       |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_NAMESPACES                                    |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_CONTROLLER_SHARDING_ALGORITHM                             |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_APPLICATION_CONTROLLER_KUBECTL_PARALLELISM_LIMIT          |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_K8SCLIENT_RETRY_MAX                                       |                                            | argocd-cmd-params-cm | x    | x      |       |      |
| ARGOCD_K8SCLIENT_RETRY_BASE_BACKOFF                              |                                            | argocd-cmd-params-cm | x    | x      |       |      |
| ARGOCD_APPLICATION_CONTROLLER_SERVER_SIDE_DIFF                   |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_IGNORE_NORMALIZER_JQ_TIMEOUT                              |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_HYDRATOR_ENABLED                                          |                                            | argocd-cmd-params-cm | x    | x      |       |      |
| ARGOCD_CLUSTER_CACHE_BATCH_EVENTS_PROCESSING                     |                                            | argocd-cmd-params-cm | x    |        |       |      |
| ARGOCD_CLUSTER_CACHE_EVENTS_PROCESSING_INTERVAL                  |                                            | argocd-cmd-params-cm | x    |        |       |      |
| KUBECACHEDIR                                                     |                                            | hardcoded            | x    |        |       |      |
| ARGOCD_SERVER_INSECURE                                           |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_BASEHREF                                           |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_ROOTPATH                                           |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_LOGFORMAT                                          |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_LOG_LEVEL                                          |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_REPO_SERVER                                        |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_DEX_SERVER                                         |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_DISABLE_AUTH                                       |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_ENABLE_GZIP                                        |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_REPO_SERVER_TIMEOUT_SECONDS                        |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_X_FRAME_OPTIONS                                    |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_CONTENT_SECURITY_POLICY                            |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_REPO_SERVER_PLAINTEXT                              |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_REPO_SERVER_STRICT_TLS                             |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_DEX_SERVER_PLAINTEXT                               |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_DEX_SERVER_STRICT_TLS                              |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_TLS_MIN_VERSION                                           |                                            | argocd-cmd-params-cm |      | x      |       | x    |
| ARGOCD_TLS_MAX_VERSION                                           |                                            | argocd-cmd-params-cm |      | x      |       | x    |
| ARGOCD_TLS_CIPHERS                                               |                                            | argocd-cmd-params-cm |      | x      |       | x    |
| ARGOCD_SERVER_CONNECTION_STATUS_CACHE_EXPIRATION                 |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_OIDC_CACHE_EXPIRATION                              |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_LOGIN_ATTEMPTS_EXPIRATION                          |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_STATIC_ASSETS                                      |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APP_STATE_CACHE_EXPIRATION                                |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_MAX_COOKIE_NUMBER                                         |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_LISTEN_ADDRESS                                     |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_METRICS_LISTEN_ADDRESS                             |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_OTLP_ADDRESS                                       |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_OTLP_INSECURE                                      |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_OTLP_HEADERS                                       |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APPLICATION_NAMESPACES                                    |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_ENABLE_PROXY_EXTENSION                             |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_API_CONTENT_TYPES                                         |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_SERVER_WEBHOOK_PARALLELISM_LIMIT                          |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_NEW_GIT_FILE_GLOBBING    |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APPLICATIONSET_CONTROLLER_SCM_ROOT_CA_PATH                |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APPLICATIONSET_CONTROLLER_ALLOWED_SCM_PROVIDERS           |                                            | argocd-cmd-params-cm |      | x      |       |      |
| ARGOCD_APPLICATIONSET_CONTROLLER_ENABLE_SCM_PROVIDERS            |                                            | argocd-cmd-params-cm |      | x      |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
|                                                                  |                                            |                      |      |        |       |      |
