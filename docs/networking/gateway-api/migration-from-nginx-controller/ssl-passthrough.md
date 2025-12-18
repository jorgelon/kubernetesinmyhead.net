# nginx.ingress.kubernetes.io/ssl-passthrough

This is applied to the connection between the client and the gateway (downstream connection). It enables SSL/TLS passthrough mode so the the Gateway forwards encrypted traffic directly to backend pods without terminating TLS at the gateway level. Routing is performed based on the SNI (Server Name Indication) field in the TLS handshake.

**Common use cases**:

- Applications that need to handle TLS termination themselves
- Mutual TLS (mTLS) where the application validates client certificates
- End-to-end encryption requirements
- Legacy applications with embedded TLS configuration

**Performance note**: In NGINX Ingress, this feature introduces a performance penalty as it bypasses NGINX's normal processing and uses a TCP proxy.

The only way to enable passthrough in gateway api is using a TLS listener protocol and a tlsroute.

See more here <https://gateway-api.sigs.k8s.io/guides/tls/>
