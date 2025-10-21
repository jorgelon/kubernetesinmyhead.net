# Add custom headers

- proxy-set-headers
for passing a custom list of headers to the upstream server

- add-headers
To pass the custom headers before sending response traffic to the client

## Easier option

## Harder option

Changes to the custom header config maps do not force a reload of the ingress-nginx-controllers.

## Configure in the controller

In the ingress-nginx-controller configmap or similar, we indicate to the controller which is our configmap that will contain our custom headers. This can be done using 2 keys

## Create the configmap

## Restart the controller

## Links

- Custom headers:  
<https://kubernetes.github.io/ingress-nginx/examples/customization/custom-headers/>
