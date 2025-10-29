# Authentication

## Roles

A Gitlab role is a set of permissions a user have under a group or project. Some examples of predefined roles are:

- guest
- reporter
- developer
- mantainer
- owner

## Scopes of access tokens

The scopes are the specific permissions a token has. This permissions can be

- Api permissions
- Repository permission
- Registry permissions
- Read user information

## Scoped tokens

The scoped tokens are credentials that have roles assigned.

Also they can have the following scopes:

- The GitLab API
- GitLab repositories
- The GitLab registry

The scoped tokens can be:

| Token Type                   | Tied to          | UI Location                      | Tied to                  |
|------------------------------|------------------|----------------------------------|--------------------------|
| Personal Access Tokens (PAT) | Individual user  | Profile > Access Tokens          | An specific user account |
| Group Access Tokens          | Specific group   | Group Settings > Access Tokens   | A group                  |
| Project Access Tokens        | Specific project | Project Settings > Access Tokens | A single project         |

## Deploy Tokens

The deploy tokens are more oriented to do certain operations like interacting with:

- GitLab repositories
- The GitLab registry

Some features:

- They do not have API permissions
- They do not have roles assigned
- They can be defined at project or group level

| Token Type           | Tied to          | UI Location                                   | Tied to                  |
|----------------------|------------------|-----------------------------------------------|--------------------------|
| Project deploy token | Specific project | Project Settings > Repository > Deploy Tokens | An specific user account |
| Group deploy token   | Specific group   | Group Settings > Repository > Deploy Tokens   | A group                  |

> Tip: If you create a token called "gitlab-deploy-token", the deploy token is automatically exposed to project CI/CD jobs as variables, where CI_DEPLOY_USER is the username and CI_DEPLOY_PASSWORD the token

## GitLab CI/CD job token

This is another special token auto generated a job is about to run and stores in the following variable: **CI_JOB_TOKEN**.

Permissions:

- The token receives the same access level as the user that triggered the pipeline
- But with less permissions than a Personal Access Token

## Links

- Roles and permissions

<https://docs.gitlab.com/user/permissions/>

- Personal access tokens

<https://docs.gitlab.com/user/profile/personal_access_tokens/>

- Group access tokens

<https://docs.gitlab.com/user/group/settings/group_access_tokens/>

- Project access tokens

<https://docs.gitlab.com/user/project/settings/project_access_tokens/>

- Deploy tokens

<https://docs.gitlab.com/user/project/deploy_tokens/>

- GitLab CI/CD job token

<https://docs.gitlab.com/ci/jobs/ci_job_token/>
