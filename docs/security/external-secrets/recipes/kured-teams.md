# Kured notifications to

Microsoft changed the url of the webhook created in Teams. In order to support kured notifications, this recipe adapts that webhook url to the new format.

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: kured-settings
spec:
 ...
  target:
    template:
      data:
        KURED_NOTIFY_URL: '{{ list .msteamsWebhookUrl "template=json&messagekey=text" | join "?" | replace "https://" "generic://" }}'
```

And in the kured values.yaml

```yaml
extraEnvVars:
  - name: KURED_NOTIFY_URL
    valueFrom:
      secretKeyRef:
        name: kured-settings
        key: KURED_NOTIFY_URL
```

## Links

- MS Teams notifications are currently broken with new message format

<https://github.com/kubereboot/kured/issues/1024>

- Add ability to set cli flags with environment variables

<https://github.com/kubereboot/kured/issues/383>
