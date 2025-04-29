# Tips

## remove a prefix from an string

Using the ltrimstr function

```shell
export KRO_VERSION=$(curl -sL \
    https://api.github.com/repos/kro-run/kro/releases/latest | \
    jq -r '.tag_name | ltrimstr("v")'
  )
```
