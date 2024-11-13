# Tips

## Get logs

Get shell with the session manager u other method and access to the admin container

```shell
enter-admin-container
```

Use sheltie

```shell
sudo sheltie
```

We can generate the logs or get kubelet logs, for example

```shell
logdog
journalctl -u kubelet
```
