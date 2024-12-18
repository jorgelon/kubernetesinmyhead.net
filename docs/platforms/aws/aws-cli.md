# AWS CLI

## Install as user

```shell
mkdir ~/apps ~/bin
bash install --install-dir ~/apps/aws-cli --bin-dir ~/bin
~/bin/aws --version
```

## Configure sso profiles

```shell
aws configure sso
```

## List profiles

```shell
aws configure list-profiles
```

## Login to a sso profile

```shell
aws sso login --profile=profile
```

## Choose profile

```shell
export AWS_PROFILE=profile
```

## List s3 buckets

```shell
aws s3 ls --profile myprofile
```

## Get my kubeconfig

```shell
export AWS_PROFILE=myprofile
aws eks update-kubeconfig --region region-code --name my-cluster --kubeconfig pathtomykubeconfig
```

## Other

```shell
aws eks get-token  --cluster-name my-cluster

aws sts get-caller-identity

aws sts get-session-token
```
