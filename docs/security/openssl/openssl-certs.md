# Openssl and web certificates

## Web certificate and RFC 6125

In the RFC 6125 the recommendation is to use the X509v3 Subject Alternative Name (SAN). It includes all the domains and subdomains this certificate will secure. It can also include ip addresses.

```txt
X509v3 Subject Alternative Name: 
    DNS:my.domain.com

In the Subject we can setup a Common Name. Examples:

```txt
Subject: CN = my.domain.com
Subject: CN = www.domain.com
Subject: CN = *.domain.com
```

> As the RFC 6125 says, the SAN is checked first. If SAN does not exists, the CN will be checked. If both are specified, the CN must match an entry in the SAN. But at this point, different clients can have different behaviours.

## Information

### Certificate information

```shell
openssl x509 -noout -text -in 'cerfile.crt'  # PEM format (default)
openssl x509 -inform pem -noout -text -in 'cerfile.cer';  # PEM format (default)
openssl x509 -inform der -noout -text -in 'cerfile.cer'; # DER format
```

## Checks

### Private key integrity

```shell
openssl rsa -check -noout -in privatekey.key
```

### Modulus (they must match)

```shell
openssl x509 -noout -modulus -in privatekey.key
openssl rsa -noout -modulus -in certificate.key
```

## Extract from pfx

### Extract the private key

```shell
openssl pkcs12 -in [yourfile.pfx] -nocerts -out [tls.key] # encrypted
openssl pkcs12 -in [yourfile.pfx] -nocerts -noenc -out [tls.key] # no encrypted
```

This asks you for the import password (the password used to protect the keypair when the .pfx file was created).
Also, for the "PEM pass phrase". This will protecdt the .key generated file. Store this "PEM pass phrase"

- Decrypt the private key if encrypted

Type the "PEM pass phrase"

```shell
openssl rsa -in [drlive.key] -out [tls-decrypted.key]
```

### Extract the certificate

This asks you for the import password (the password used to protect the keypair when the .pfx file was created).

```shell
openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [tls.crt]
```

### Extract the ca

This asks you for the import password (the password used to protect the keypair when the .pfx file was created).

```shell
openssl pkcs12 -in [yourfile.pfx] -cacerts -nokeys -out [tls.ca]
```
