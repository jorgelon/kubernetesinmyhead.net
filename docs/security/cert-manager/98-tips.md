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

## Auto clean secrets

By default cert-manager does not remove a secret when the certificate is removed. We can enable it with the following controller option:

```txt
--enable-certificate-owner-ref
```

For example, deleting an ingress resource removes the certificate. With this setting, also the secret

> This setting makes the certificate resource as an owner of secret where the tls certificate is stored.
