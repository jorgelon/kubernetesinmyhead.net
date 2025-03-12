# AWS load balancer controller

At application level

```yaml
      ignoreDifferences:
        - kind: Secret
          name: aws-load-balancer-controller-tls
          jsonPointers:
            - /data/ca.crt
            - /data/tls.crt
            - /data/tls.key
        - group: admissionregistration.k8s.io
          kind: MutatingWebhookConfiguration
          name: aws-load-balancer-controller-webhook
          jsonPointers:
            - /webhooks/0/clientConfig/caBundle
            - /webhooks/1/clientConfig/caBundle
            - /webhooks/2/clientConfig/caBundle
        - group: admissionregistration.k8s.io
          kind: ValidatingWebhookConfiguration
          name: aws-load-balancer-controller-webhook
          jsonPointers:
            - /webhooks/0/clientConfig/caBundle
            - /webhooks/1/clientConfig/caBundle
            - /webhooks/2/clientConfig/caBundle
```
