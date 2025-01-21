# Aws cli and ecr

Get a token valid for 12 hours

```shell
aws ecr get-login-password --region MYREGION 
```

Get a token valid for 12 hours and login in docker

```shell
aws ecr get-login-password --region MYREGION | docker login --username AWS --password-stdin MYACCOUNTID.dkr.ecr.MYREGION.amazonaws.com
```

Create a repository

```shell
aws ecr create-repository --repository-name REPOSITORYNAME
```
