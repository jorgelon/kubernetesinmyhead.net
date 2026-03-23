# Control non TCP connection 

Cilium maintains the non TCP connections in a connection tracking table

by default they are cleaned by a garbage collector dynamically depending of the traffic

conntrack-gc-interval=0

it is possible to configure a fixed interval

conntrack-gc-interval=5m

or define a maximum interval

conntrackGCMaxInterval


https://docs.cilium.io/en/stable/network/ebpf/maps/

https://docs.cilium.io/en/stable/operations/troubleshooting/