# Tips

## parametersRef in GatewayClass and Gateway parametersRef

The `parametersRef` field exists at two levels in Gateway API, and they serve **different purposes**:

- **`GatewayClass.spec.parametersRef`**: Cluster-wide default configuration applied to *all* Gateways using that class
- **`Gateway.spec.infrastructure.parametersRef`**: Per-Gateway instance-specific overrides

This design avoids the "combinatorial explosion" of GatewayClass resources. Without per-Gateway `parametersRef`, you'd need separate GatewayClasses for every configuration variation (e.g., `gateway-internet-ipv4`, `gateway-internet-ipv6`, `gateway-private-ipv4`, etc.).

When both `GatewayClass.spec.parametersRef` and `Gateway.spec.infrastructure.parametersRef` are specified, the merging behavior is **implementation-specific**. The general recommendation:

- **GatewayClass parametersRef**: Provides sensible defaults for the class
- **Gateway parametersRef**: Allows team-specific or instance-specific overrides

This follows the principle of least privilege—use GatewayClass for defaults, Gateway for customization.
