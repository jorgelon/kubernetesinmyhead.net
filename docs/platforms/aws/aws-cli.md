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

## Login to ecr

```shell
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
```

## Other

```shell
aws eks get-token  --cluster-name my-cluster

aws sts get-caller-identity

aws sts get-session-token
```

To delete a profile with the AWS CLI, you need to manually remove the profile's configuration from the AWS configuration files. The AWS CLI stores profiles in two files: ~/.aws/config and ~/.aws/credentials.

Steps to Delete a Profile:
Open the Configuration Files:

Open ~/.aws/config and ~/.aws/credentials in a text editor.
Remove the Profile from ~/.aws/config:

Locate the profile section you want to delete. Profile sections start with [profile profile-name] for named profiles.
Delete the entire section for the profile.
Remove the Profile from ~/.aws/credentials:

Locate the profile section you want to delete. Profile sections start with [profile-name].
Delete the entire section for the profile.
