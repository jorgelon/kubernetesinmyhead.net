# Tips

## A CI/CD variable contains a $

If a gitlab cicd variable contains a $, we can escape it addin another $ in the value

```txt
asljfrower$34onamdgflg > asljfrower$$34onamdgflg
```

## Credentials to pull image

- create a credential with pull permissions in your registry

- Add a masked variable to the CI/CD with this format

```txt
name: DOCKER_AUTH_CONFIG
value: {"auths":{"FQDN":{"username":"your-username","password":"your-password"}}}
```

And thats it. GitLab will automatically use these credentials to authenticate with your registry. The authentication happens at the GitLab Runner level, not within your job container.

- Run your CI/CD jobs in Docker containers

<https://docs.gitlab.com/ci/docker/using_docker_images/>
