# Tips

## No installed keys could decrypt the message

After a metallb version update, the daemonset logs show

```txt
memberlist: failed to receive: No installed keys could decrypt the message from=XXX.XXX.XXX.XXX:36946
```

Solution

```shell
kubectl delete pods -n metallb-system --all
```

Then we can see

```txt
memberlist join successfully
```
