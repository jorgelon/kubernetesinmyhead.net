# Tips

## Gateway Listener vs AWS Load Balancer Listener

See [gateway-vs-aws-listeners.md](gateway-vs-aws-listeners.md) for detailed information about the difference between Gateway API listeners and AWS Load Balancer listeners, including lifecycle, configuration, and settings management.

## TLS section ignore

AWS load balancer controller seems to ignore the tls section in the listeners because the certificates are discovered in ACM via hostname matching

## TLSroute, SNI Routing in NLB

AWS Network Load Balancer does not support SNI routing because TLSRoute resources here are not conformant to the Gateway API spec (select traffic to target groups per hostname matching). The recommendation is to use TCPRoute resources.

<https://github.com/kubernetes-sigs/aws-load-balancer-controller/issues/4561>

## Protocols in Network Load Balancer

See [protocols.md](protocols.md) for detailed information about Gateway API and AWS NLB protocol concepts, mappings, and common scenarios.
