# Mover datos sensibles a un secret nuestro

Argocd permite poner el valor de un key de un configmap o secret en otro secret creado por nosotros.

> El uso de external secrets operator con merge aplicado al argocd-secret puede dar problemas, asi que no esta de mas sacar esa configuracion a otro secret, lo que es menos intrusivo

## Creacion del secret

Para ello necesitamos crear un secret con los valores KEY-NUESTRO-SECRET: VALOR-KEY-NUESTRO-SECRET  
> Es importante que el secret este en el namespace argocd y tenga el label app.kubernetes.io/part-of: argocd

Por ejemplo, si queremos hacerlo con el secret de un webhook de github

```yaml
apiVersion: v1
data:
  webhook.github.secret: LO-QUE-SEA-EN-BASE64
immutable: false
kind: Secret
metadata:
  labels:
    app.kubernetes.io/part-of: argocd
  name: webhook
  namespace: argocd
type: Opaque
```

## Apuntar a ese secret

Ahora debemos hacer que el valor del configpmap o secret apunte a ese secret nuestro. Asi que cambiamos el valor por un referencia a nuestro secret, con este formato:

```txt
KEY: $NUESTRO-SECRET:KEY-DE-NUESTRO-SECRET
```

En nuestro ejemplo, podriamos hacer un overlay con kustomize al argocd secret original con esto

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
type: Opaque
stringData:
webhook.github.secret: $webhook:webhook.github.secret
```

## Reiniciar argocd-server

Estos cambios fuerzan un reinicio de la configuracion del argocd-server, pero hay un bug que hace que no sea suficiente, asi que toca reiniciarlo a mano

```shell
kubectl rollout restart deployment argocd-server -n argocd
```

## Nota: Argocd ya lo usa

Si echamos un vistazo a las configuraciones para oidc en argocd se usan configuraciones como esta en el argocd-cm

- clientSecret: $oidc.keycloak.clientSecret
- clientSecret: $dex.oidc.clientSecret
- clientSecret: $oidc.okta.clientSecret
- clientSecret: $oidc.azure.clientSecret

Aqui el nombre del secret no esta puesto tras "$", entiendo que por defecto busca en el argocd-secret

## Links

- User management alternative
<https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#alternative>

- Git Webhook Configuration alternative
<https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/#alternative>

- ArgoCD server doesn't pick up the new OIDC secret #18576  
<https://github.com/argoproj/argo-cd/issues/18576>
