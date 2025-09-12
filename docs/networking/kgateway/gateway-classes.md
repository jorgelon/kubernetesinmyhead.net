# Gateway Classes

## kgateway vs kgateway-waypoint GatewayClasses

### kgateway

- Purpose: Standard class for managing Gateway API ingress traffic
- Use case: Regular ingress/gateway functionality for external traffic routing
- Description: "Standard class for managing Gateway API ingress traffic"

### kgateway-waypoint

- Purpose: Specialized class for Istio ambient mesh waypoint proxies
- Use case: Service mesh integration with Istio ambient mode
- Description: "Specialized class for Istio ambient mesh waypoint proxies"
- Special annotation: ambient.istio.io/waypoint-inbound-binding: PROXY/15088 - indicates integration with Istio ambient mesh waypoint functionality

### Comparison

Common characteristics

- Both use the same controller: kgateway.dev/kgateway
- Both are managed by the same kgateway installation
- Both have Accepted and SupportedVersion conditions

The main difference is that kgateway-waypoint is specifically designed for Istio service mesh ambient mode waypoint proxy functionality, while kgateway is for standard ingress traffic routing.
