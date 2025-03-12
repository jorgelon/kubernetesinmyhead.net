# Vmware harbor

At application level

```yaml
      ignoreDifferences:
        - group: apps
          kind: Deployment
          name: harbor-jobservice
          jsonPointers:
            - /spec/template/metadata/annotations/checksum~1secret
            - /spec/template/metadata/annotations/checksum~1secret-core
        - group: apps
          kind: Deployment
          name: harbor-core
          jsonPointers:
            - /spec/template/metadata/annotations/checksum~1secret
            - /spec/template/metadata/annotations/checksum~1secret-jobservice
        - group: apps
          kind: Deployment
          name: harbor-registry
          jsonPointers:
            - /spec/template/metadata/annotations/checksum~1secret
            - /spec/template/metadata/annotations/checksum~1secret-core
            - /spec/template/metadata/annotations/checksum~1secret-jobservice
        - group: ""
          kind: Secret
          name: harbor-core
          jsonPointers:
            - /data/CSRF_KEY
            - /data/secret
            - /data/tls.crt
            - /data/tls.key
        - group: ""
          kind: Secret
          name: harbor-jobservice
          jsonPointers:
            - /data/JOBSERVICE_SECRET
        - group: ""
          kind: Secret
          name: harbor-registry
          jsonPointers:
            - /data/REGISTRY_HTTP_SECRET
        - group: ""
          kind: Secret
          name: harbor-registry-htpasswd
          jsonPointers:
            - /data/REGISTRY_HTPASSWD
```
