# Tips

## AWS listener and Gateway API listener

There is a name conflict here because they are different things

- An AWS listener is defined in the AWS load balancer. They are created when a route is created
- A Gateway API listener is defined in the Gateway resource but does not creates an AWS listener in the load balancer

## Gatewayclass and Gateway settings

Both the Gatewayclass and Gateway resources can use a LoadBalancerConfiguration resource as settings. When creating a Gateway with its LoadBalancerConfiguration under a gatewayclass with is LoadBalancerConfiguration, both settings are merged

## Gateway creation an aws listener settings

The creation of a Gateway resource creates the aws loadbalancer only

- It will be a NLB if the gateway class has gateway.k8s.aws/nlb as spec.controllerName
- It will be an ALB if the gateway class has gateway.k8s.aws/alb as spec.controllerName

This does not create listeners, they will be created when deploying routes under the gateway, the but we can configure the settings that the listeners will have via a LoadBalancerConfiguration resource.

This settings are located under spec.listenerConfigurations in the LoadBalancerConfiguration resource and for every listener defined here we can find things like:

- protocol + port combination (protocolPort)
- default ssl certificate (defaultCertificate)
- a list of certificates to add (certificates)
- target group stickiness (targetGroupStickiness)
- ALPN policy (alpnPolicy)
- mutual authentication (mutualAuthentication)
- enable quic protocol for udp (quicEnabled)
- other listener attributes (listenerAttributes)

## TLS section ignore

AWS load balancer controller seems to ignore the tls section in the listeners because the certificates are discovered in ACM via hostname matching
