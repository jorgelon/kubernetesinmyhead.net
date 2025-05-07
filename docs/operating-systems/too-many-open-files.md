# Too Many Open Files

This error is related with the max open file descriptors limit.

To see list the opened file descriptors per process (open file descriptors, pid an process name):

```shell
for pid in $(ls /proc | grep -E '^[0-9]+$'); do
  echo "$(ls /proc/$pid/fd 2>/dev/null | wc -l) $pid $(cat /proc/$pid/comm 2>/dev/null)"
done | sort -nr | head
```

## Systemd service

In order to see if the problem is related with a systemd service, we can see the limits this way

With containerd:

```shell
systemctl show containerd | grep LimitNOFILE
cat /proc/$(pgrep containerd | head -1)/limits | grep files
```

In order to solve it we can:

- Change the DefaultLimitNOFILE settings in the /etc/systemd/system.conf file, affecting to all systemd services.

> The default value is 1024:524288, where 1024 is the soft limit and 524288 the hard limit

- Or adding a systemd dropping in /etc/systemd/system/containerd.service.d/limits.conf with our desired LimitNOFILE

## System process

If the problem is related with a non systemd service, we must probably increase fs.inotify.max_user_instances. This is the upper limit on the number of INotify instances (file descriptors) that can be created per real user ID

To see the current settings

```shell
sysctl fs.inotify.max_user_instances
cat /proc/sys/fs/inotify/max_user_instances
```

To increase it temporarily (sometimes the default value is 128)

```shell
sysctl fs.inotify.max_user_instances=512
```

To make it persistent

```shell
cat << EOF > /etc/sysctl.d/10-open-files.conf
fs.inotify.max_user_instances = 512
EOF
systemctl restart systemd-sysctl.service
```

And check again the current settings
