# Authentication

## Common

List profiles

```shell
aws configure list-profiles
```

Choose profile

```shell
export AWS_PROFILE=profile
```

Files

~/.aws/credentials

~/.aws/config

## Standard profile

Configure standard profile

```shell
aws configure
```

## Single Sign on (ssl)

Configure sso profile

```shell
aws configure sso
```

Login to a sso profile

```shell
aws sso login --profile=profile
```
