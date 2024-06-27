# Perlas

## Como utilizar una variable de entorno de un container como un argumento del mismo

Una de las formas de consumir una variable de entorno de un contenedor puede ser dentro de un argumento. Para ello hay que utilizar el siguiente formato:

```shell
$(VAR_NAME)
```

Por ejemplo

```yaml
args:
- echo 
- $(VAR_NAME)
env:
- name: VAR_NAME
  value: myvalue
```
