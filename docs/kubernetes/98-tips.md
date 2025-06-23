# Tips

## How to use an environment variable as an arguement

We must use this format

```shell
$(VAR_NAME)
```

For example

```yaml
args:
- echo 
- $(VAR_NAME)
env:
- name: VAR_NAME
  value: myvalue
```
