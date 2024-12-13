# Http

The http argo workflows template permit to do some http requests.

## Rbac Permissions

The http template uses the argo agent, not the workflow controller.
When a workflow that uses the argo agent is created, a WorkflowTaskSet is created so we have to give additional permissions:

- to the service account specified in the workflow (default sa: default but change it is recommended)
- to the service account of the workflow controller (default sa: argo)

The needed permissions are

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: executor-http
rules:
  - apiGroups:
      - argoproj.io
    resources:
      - workflowtasksets
    verbs:
      - list
      - watch
  - apiGroups:
      - argoproj.io
    resources:
      - workflowtasksets/status
    verbs:
      - patch
```

More info about this

- <https://raw.githubusercontent.com/argoproj/argo-workflows/refs/heads/main/manifests/quick-start/base/agent-role.yaml>
- <https://github.com/argoproj/argo-workflows/issues/13770>
- <https://github.com/argoproj/argo-workflows/issues/10340>
- <https://argo-workflows.readthedocs.io/en/stable/upgrading/#06d4bf76f-fix-reduce-agent-permissions-fixes-7986-7987>

## Secret

Another requirement is to create a secret as described here

<https://github.com/argoproj/argo-workflows/issues/10340>

## executor-http service account permissions

If we create a service account called executor-http to execute the http templates, we can use this to give the minimum permissions.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: executor-http
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: executor-http
rules:
  - apiGroups:
      - argoproj.io
    resources:
      - workflowtasksets
    verbs:
      - list
      - watch
  - apiGroups:
      - argoproj.io
    resources:
      - workflowtasksets/status
    verbs:
      - patch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: executor-http
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: executor-http
subjects:
  - kind: ServiceAccount
    name: executor-http
    namespace: argo
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: executor-http
  name: executor-http.service-account-token
type: kubernetes.io/service-account-token
```

## Options

Inside the http template we can use some configurations:

- url: to pass the url of the endpoint. With insecureSkipVerify we can ignore not known certificates
- body and bodyFrom: to pass the body
- headers: array with http headers we want to pass (name, value and valueFrom)
- method: the method of the request
- successCondition: what make the request successfull
- timeoutSeconds: timeout of the request (default 30s)

## Outputs

outputs.result in an HTTP template stores the response body

## Bugs | Missing features

- Workflow-controller was unable to obtain node

<https://github.com/argoproj/argo-workflows/issues/13847>

- Enable PodGC for the agent pod

<https://github.com/argoproj/argo-workflows/issues/12692>

## Links

- HTTP Template

<https://argo-workflows.readthedocs.io/en/latest/http-template/>

- HTTP spec

<https://argo-workflows.readthedocs.io/en/stable/fields/#http>
