# Merging from class

When creating a GatewayClass there is an optional field spec.parametersref that permits to configure it custom implementation settings

Also, when creating a gateway we can configure it with custom implementation settings using spec.infrastructure.parametersref

The gateway api specification recommends the GatewayClass to provide defaults that can be overriden by a Gateway, but when both setting exists, the merging behaviour depends of the implementation

## Aws load balancer controller

The resource we can use to configure both is called LoadBalancerConfiguration

In this implementation Gateways ALWAYS inherit the LoadBalancerConfiguration from their GatewayClass.

- When there are no conflicting fields, both configurations are simply combined
- When there are conflicting fields between the two configurations we can choose the desired behaviour using spec.mergingMode in the LoadBalancerConfiguration resource applied in the GatewayClass. The 2 possible values are prefer-gateway-class and prefer-gateway

## Envoy gateway

The resource we can use to configure both is called EnvoyProxy

In 1.6 version it is not well documenented. We can read

"You can also attach the EnvoyProxy resource to the GatewayClass using the parametersRef field. This configuration is discouraged if you plan on creating multiple Gateways linking to the same GatewayClass and would like different infrastructure configurations for each of them."

This suggest a replacement model. The Gateway inherits from GatewayClass only if Gateway doesn't specify its own EnvoyProxy
