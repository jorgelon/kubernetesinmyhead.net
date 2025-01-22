# All images from private ECR and no inet

## Situation

- The cluster has been predeployed with kubeadm and temporary internet access. The control plane is working but that container images will not be accesible if they need to be downloaded again.

- We dont have internet access in our kubernetes cluster
The cluster must get all the container images from an Amazon Elastic Container Registry. AWS gives a 12 hours valid token for that. We need to renew it properly.
We cannot access to helm repositories

- All the secrets will be stored in AWS Secrets Manager and we will use external secrets operator v0.12.1

## Preparation

### Power user

We will do some tasks like create repositories, iam policies, iam users, push image or create secrets. We need permissions to do that operations.
For example, to push images we ca use the predefined AmazonEC2ContainerRegistryPowerUser policy or use a more precise setup.

> Assume that user will be called "power-user"

### Iam user to pull images

We must create an iam user to permite kubelet and the service accounts to pull the images. We can use the generic AmazonEC2ContainerRegistryPullOnly predefined policy or do a more precise setup.

> Assume that user will be called "image-puller"

Also create an access key and store the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY in secrets manager:

```txt
image-puller-AWS_ACCESS_KEY_ID
image-puller-AWS_SECRET_ACCESS_KEY
image-puller-REGION
```

## Bootstrap external-secrets operator

Because all the container images will be located in a private repository we need to bootstrap external secrets operator in order to provide kubelet the credentials to that private repository in a secure way.

### External secrets repository

Go to Elastic Container Registry and create a repository called, for example, MYPROJECT/external-secrets. Take care about the resulting Resource ARN and URL of the repository.

```txt
MYREPOARN
MYREPOURL
```

### Push the external secrets image

Pull the external-secrets operator official image for our release

```shell
docker pull oci.external-secrets.io/external-secrets/external-secrets:v0.12.1
docker tag oci.external-secrets.io/external-secrets/external-secrets:v0.12.1 MYREPOURL/external-secrets:v0.12.1
```

As power user push it to the new repository

```shell
aws ecr get-login-password --region MYREGION | docker login --username AWS --password-stdin MYACCOUNTID.dkr.ecr.MYREGION.amazonaws.com
docker push oci.external-secrets.io/external-secrets/external-secrets:v0.12.1 MYREPOURL/external-secrets:v0.12.1
```

### Create the kubelet credentials

For that we need to create a kubernetes.io/dockerconfigjson kubernetes secret in the external-secrets with the credentials. We will call it "puller".

- The server will be MYREPOURL
- The username will be AWS
- The password is a 12h valid token

```shell
aws configure --profile image-puller # use the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and REGION
export AWS_PROFILE=image-puller
kubectl create ns external-secrets
kubectl create secret docker-registry puller -n external-secrets --docker-server=MYREPOURL --docker-username=AWS --docker-password=$(aws ecr get-login-password) --dry-run -o yaml
```

### Deploy the operator

In order to deploy the operator we need to use the official yaml (not the helm chart), change the url of the images to our private repository repository and give the service accounts the kubelet credentials.

See [this kustomization file](private-ecr-no-inet/bootstrap-eso/kustomization.yaml) and [the imagepullsecrets patch file](private-ecr-no-inet/bootstrap-eso/sa-imagepullsecrets.yaml)

Finally deploy external secrets operator with

```shell
kubectl apply -k .
```

## Notes about pending tasks

Now we have a puller secret in the external-secrets namespace that can pull images from our container but we have several things to do:

- Create new repositories in ECR and pull all the images. It will not be treated here
- Change all the service accounts use the ecr-auth credentials as pullsecret.
- Convert the puller secret to be an managed (not manual) secret.
- Distribute the puller secret to all namespaces.
- The token lives 12 hours. We also needs to renew it.

## Links

- Pushing a Docker image to an Amazon ECR private repository

<https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html>

- External secrets operator helm chart

<https://github.com/external-secrets/external-secrets/tree/main/deploy/charts/external-secrets>

- Generators

<https://external-secrets.io/latest/guides/generator/>

- External secrets operator and ecr generator

<https://external-secrets.io/latest/api/generator/ecr/>

- External secrets operator cluster external secret

<https://external-secrets.io/latest/api/clusterexternalsecret/>
