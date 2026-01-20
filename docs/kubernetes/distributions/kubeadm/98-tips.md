# Kubeadm tips

## Auto clean kubeadm backups

This command configures tmp systemd-tmpfiles-clean to delete kubeadm backups older than 6 months

```shell
cat << EOF >> /etc/tmpfiles.d/kubeadm-tmp.conf
e    /etc/kubernetes/tmp/kubeadm*        -    -    -    6M
EOF
```

And execute it with

```shell
systemd-tmpfiles --clean /etc/tmpfiles.d/kubeadm-tmp.conf
```

Or restart the service

```shell
systemctl restart systemd-tmpfiles-clean.service
```
