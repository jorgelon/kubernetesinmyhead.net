# Generators

A generator create new argocd applications based in some criteria. It also provides some parameters that they can be used in the templates that define the applications.

Inside an ApplicationSet resource, the generators are defined under spec.generators field

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: myappset
spec:
  generators:
    ...
```

## List generator

Here you define a list of elements with one or more key/value pairs. Every element is an application and every key/value pair are variables you can use in the templates.

## Cluster generator

This generator creates new applications dinamically when the kubernetes clusters are added to an argocd instance. They also provide some variables|parameters to be used in the template definition like the cluster name or the server name. It is also possible to filter what clusters will receive that application with labels.

> It is possible to pass arbitrary values using the values field. This also generates new parameters

## Git generator

The git generator creates applications searching for files and folders in a git repository.
Using git generator folder, they can contain for example, kustomize based applications or a helm chart.
Using git generator files, you can include arbitraty parameters inside the configured files ready to be used in the template section
In both cases we get some parameters related with the discovered paths.

## Matrix generator

The matrix generator is a combination of 2 generator and it creates applications and parameters using all possible combinations between them.
For example, if the two combined generators create 3 and 4 applications, the matrix generator will create 12 applications and its corresponding parameters.
Inside a matrix generator it is also possible to use a parameter created in a child generator inside the other one.

## Merge generator

We can also mix more that one generator here. In this case, the first one is the base generator and the parameters can be overriden with the following generators.

## SCM Provider generator

This generator discovers repositories in a Software Configuration Management (SCM). Some supported SCMs are github, gitlab, gitea, bitbucket or Azure Devops. Also some parameters are generated like the organization, repository name, repository url,...

## Pull Request generator

This generator creates applications when a pull request is detected within a repository located in a SCM. The generated parameters can include the idnumber of the pull request, the title, the branch, the target branch,...

## Cluster Decision Resource generator

pending

## Plugin generator

pending
