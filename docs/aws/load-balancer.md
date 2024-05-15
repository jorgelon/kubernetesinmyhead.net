# Formas de exponer servicios en eks

- Network Load Balancer (NLB)

Via Network Load Balancer se puede exponer un servicio a nivel de capa 4
Se define mediante anotaciones en los servicios

- Application Load Balancer

Es a nivel de capa 7 y viene a sustituir a un ingress controller
Se define mediante anotaciones en un ingress controller, desarrollado inicialmente por Ticketmaster

> El AWS Loadbalancer controller interpreta dichas anotaciones

## Links

- Comparativa de features  
<https://aws.amazon.com/elasticloadbalancing/features/>

- Network load balancer  
<https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html>

- Network load balancer en eks  
<https://docs.aws.amazon.com/eks/latest/userguide/network-load-balancing.html>

- Network load balancer TLS termination  
<https://aws.amazon.com/blogs/aws/new-tls-termination-for-network-load-balancers/>

- Application load balancer  
<https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html>
<https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html> # en eks

- AWS Load balancer controller  
<https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html>
<https://kubernetes-sigs.github.io/aws-load-balancer-controller/>
