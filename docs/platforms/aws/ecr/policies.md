# Iam Policies

Example policies:

- AmazonEC2ContainerRegistryPowerUser is a predefined policy that permits an user to pull and push images

- [Project power user](project-power-user.json) as an user that can pull and push images only under MYPROJECT/* repositories

- AmazonEC2ContainerRegistryPullOnly is a predefined policy that can be assigned to service accounts to pull images

- [Project puller](project-puller.json) to be assigned to service accounts to pull images only located under MYPROJECT/* repositories
