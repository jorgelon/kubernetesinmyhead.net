# Multiple controllers

You can have more than one ingress controller and ingress class in the same Kubernetes cluster using the nginx ingress controller.

To do this, we need to install a new controller, preferably in another namespace. To prevent it from overwriting the previous one, we must add this configuration to the helm chart

## Default values of a helm chart

```yaml
controller:
  ingressClass: minuevovalor
  ingressClassResource:
    name: minuevovalor
    controllerValue: "k8s.io/minuevovalor"
```

The default installation uses

```yaml
controller:
  ingressClass: nginx
  ingressClassResource:
    name: nginx
    controllerValue: "k8s.io/ingress-nginx"
```

> controller.electionID is also a configurable value, which by default takes the controller name and adds the suffix "-leader"

## Links

- Multiple Ingress controllers  
<https://kubernetes.github.io/ingress-nginx/user-guide/multiple-ingress/>
