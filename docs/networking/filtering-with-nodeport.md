# Good/Bad news filtering in NSX-T/Nodeport

Lets assume this scenario

- Kubernetes cluster under vmware
- Loadbalancing is done manually, not using NSX Container Plug-in
- No Loadbalancer service type will work. We will use nodePort

We want to create a gateway using envoy gateway that filters by source ip:

- Bad news:

loadBalancerSourceRanges is not available in a nodePort service

- Good news:

envoy gateway provides a CRD called SecurityPolicy that permits that filter

- Bad news:

We need externalTrafficPolicy: Local to preserve source ip and make the filter work

- Good news:

By default envoy exposes their gateways with externalTrafficPolicy: Local

- Bad news:

In order to make externalTrafficPolicy: Local work, we need to make NSX-T to know in what node the gateway is deployed. Otherwise the traffic will be dropped.
This is, we need to make a healthcheck

- Good news:

We have spec.healthCheckNodePort permits to define a healthcheck where the externalTrafficPolicy is set to Local

- Bad news:

It only works with LoadBalancer services

- Good news:

We can achieve it with a monitor that makes a tcp check in the service node port, and then attach it to a server pool
