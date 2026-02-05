# Tips

## Gateway Listener vs AWS Load Balancer Listener

See [gateway-vs-aws-listeners.md](gateway-vs-aws-listeners.md) for detailed information about the difference between Gateway API listeners and AWS Load Balancer listeners, including lifecycle, configuration, and settings management.

## TLS section ignore

AWS load balancer controller seems to ignore the tls section in the listeners because the certificates are discovered in ACM via hostname matching

## TLSRoute and SNI Routing

See [nlb-sni-limitations.md](nlb-sni-limitations.md) for detailed information about why AWS NLB does not support SNI routing, TLSRoute non-conformance to Gateway API spec, and recommended architectural patterns using TCPRoute.

## Protocols in Network Load Balancer

See [protocols.md](protocols.md) for detailed information about Gateway API and AWS NLB protocol concepts, mappings, and common scenarios.
