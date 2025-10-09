# 2 Ways to create a rollout

There are 2 ways to create a rollout in argo rollouts

## Single resource

The first way needs to create a single rollout resource (excluding the service, ingress,..) that includes the logic of the rollout and the logic of the deployment via **spec.template**.

This way does not create a deployment resource.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: rollout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rollout
  template:
    metadata:
      labels:
        app: rollout
    spec:
      containers:
      - name: nginx
        image: nginx:latest
  strategy:
    blueGreen:
      activeService: rollout
      autoPromotionEnabled: false
```

## Separate rollout and deployment

The second one is with 2 workload resources. First you create the deployment as your wish. Then you create a rollout resource without spec.template but using **spec.workloadRef** referencing the existing deployment.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment
spec:
  replicas: 0 # we usually want 0 replicas here. see below
  selector:
    matchLabels:
      app: deployment
  template:
    metadata:
      labels:
        app: deployment
    spec:
      containers:
      - image: nginx:latest
        name: nginx
```

> The point to define 0 replicas in the deployment is because the rollout has its own spec.replicas field. If we leave empty (1) or more replicas in the spec.replicas field of the deployment, this will deploy them in addition to the replicas managed by the rollout. And usually this is not a desired behaviour.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: deployment
spec:
  replicas: 3 # it is better to control them here
  selector:
    matchLabels:
      app: deployment
  workloadRef: 
    apiVersion: apps/v1
    kind: Deployment
    name: deployment
  strategy:
    blueGreen:
      activeService: deployment
      autoPromotionEnabled: false
```
