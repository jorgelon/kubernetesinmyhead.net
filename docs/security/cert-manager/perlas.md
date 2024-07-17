# Perlas

## Pod identity agent

Para poder usar AWS Pod identity agent en un issuer es necesario habilitar en el controller

```txt
--issuer-ambient-credentials
```

Para cluster issuer viene habilitado por defecto

Para poder usarlo es posible que necesites una version mas reciente de cert-manager. En 1.12 no parece funcionar

## http: TLS handshake error from XXXX EOF

Borrar a mano cert-manager-webhook-ca y cert-manager-webhook-tls si existen
