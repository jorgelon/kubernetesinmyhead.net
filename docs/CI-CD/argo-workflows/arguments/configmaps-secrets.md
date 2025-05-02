# Parameters in secrets and configmaps

## Parameters in a configmap

If we want to get the parameters from a configmap we must label that configmap with this label

```txt
workflows.argoproj.io/configmap-type: Parameter
```

Then we can consume it using "valueFrom" "configMapKeyRef"

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: arguments-parameters-from-configmap-
spec:
  entrypoint: print-message-from-configmap
  templates:
  - name: print-message-from-configmap
    inputs:
      parameters:
      - name: message
        valueFrom:
          configMapKeyRef:
            name: simple-parameters
            key: msg
    container:
      image: busybox
      command: ["echo"]
      args: ["{{inputs.parameters.message}}"]
```

## Parameters in a secret

But if we want to store that parameter in a kubernetes secret we must use it:

- As an environment variable

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: secret-example-
spec:
  entrypoint: print-secrets
  templates:
  - name: print-secrets
    container:
      image: alpine:3.7
      command: [sh, -c]
      args: ['
        echo "secret from env: $MYSECRETPASSWORD"
      ']
      env:
      - name: MYSECRETPASSWORD
        valueFrom:
          secretKeyRef:
            name: my-secret
            key: mypassword
```

- As a volume

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: secret-example-
spec:
  entrypoint: print-secrets
  volumes:
  - name: my-secret-vol
    secret:
      secretName: my-secret
  templates:
  - name: print-secrets
    container:
      image: alpine:3.7
      command: [sh, -c]
      args: ['
        echo "secret from file: `cat /secret/mountpath/mypassword`"
      ']
      volumeMounts:
      - name: my-secret-vol
        mountPath: "/secret/mountpath"
```

## Links

<https://argo-workflows.readthedocs.io/en/stable/walk-through/secrets/>
