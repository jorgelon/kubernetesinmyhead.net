# Renovate phases

## Configurations

The first step is to merge the configurations. From more important to less:

```txt
cli > env > file > default
```

## Cloning

Then the **platform module** interacts with the source control platform and clones the list of configured repositories.

> There are some supported platforms we can configure, such as azure, bitbucket, github, gitlab, gitea,...

More information about platforms here:

<https://docs.renovatebot.com/modules/platform/>

## Vulnerabilities

Next there is check for vulnerabilities.

Is it possible to only update dependencies if vulnerabilities have been detected (security:only-security-updates)

## Extract dependencies with package managers

Then the **manager module** looks for files based on **their name** and extracts the dependencies.
It assigns a datasource to each extracted package file or dependency. The datasource tells Renovate how to search for new versions.

> Example: The gitlabci manager finds a dependency: python:3.10-alpine which has the docker datasource

Some package managers are ansible, helm-values, argocd,... and it is possible to reconfigure the file match.

More info about the package managers module here:

<https://docs.renovatebot.com/modules/manager/>

## Look up updates

Then the **datasource module** looks for available versions of the dependency looking up registries.

> Example: The docker datasource looks for versions and finds: [python:3.9,python:3.9-alpine,python:3.10,python:3.10-alpine,python:3.11,python:3.11-alpine]

Some datasources are docker, github-releases, helm, ruby-gems

More info about the datasources module here:

<https://docs.renovatebot.com/modules/datasource/>

## Versioning

Once we have located available versions, the versioning module will use a scheme to perform sorting and filtering of results.

> Example: The docker versioning returns python:3.11-alpine, because that version is compatible with python:3.10-alpine

It is usually recommended to configure the versioning because the default way can fail in some scenarios.

More info about versioning module here:

<https://docs.renovatebot.com/modules/versioning/>

## Write updates

Once the updates has been chosen, the changes are pushed to the repository depending how it is configured

## Links

- How renovate works
<https://docs.renovatebot.com/key-concepts/how-renovate-works/>
