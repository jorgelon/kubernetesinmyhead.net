# Tips

## Get admin console access in EKS

Connect the ec2 instance, for example, using session manager. Then

```shell
enter-admin-container
sudo sheltie
```

## Get logs

We can generate the logs or get kubelet logs, for example

```shell
logdog
journalctl -u kubelet
```

## Get the kubernetes images

```shell
ctr --namespace k8s.io images list
```

## Re-Push the  kubernetes images

This will ask you for the password

```shell
ctr --namespace k8s.io image push -u MYUSER URL-OF-THE-IMAGE
```
