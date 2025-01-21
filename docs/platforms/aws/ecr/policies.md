# Iam Policies

We can use 2 policies as starting point:

- AmazonEC2ContainerRegistryPowerUser as an user that can pull and push images

- [Project power user](project-power-user.json) as an user that can pull and push images only MYPROJECT/* repositories

- AmazonEC2ContainerRegistryPullOnly to be assigned to service accounts to pull images

- [Project puller](project-puller.json) to be assigned to service accounts to pull images only located in MYPROJECT/* repositories
