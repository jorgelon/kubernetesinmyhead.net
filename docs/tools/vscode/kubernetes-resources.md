# Kubernetes syntax

How to enable systax for kubernetes resources (and other yaml files)

## Install and enable the yaml extension

Install the redhat yaml extension

<https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml>

And associate the yaml files to it in the settings.json vscode file (at user or workspace level)

```json
    "files.associations": {
        "*.yaml": "yaml"
    },
```

## Yaml schemas

We can associate an url or local file containing a json schema to files with the **yaml.schemas** setting.

```json
"yaml.schemas": {
    "kubernetes": "*.yaml"
},
```

But this will not recognize CRDs. For that we need to get the json schema for that CRDs and associate them with files using, for example, patterns.

### Where to get the CRDs

A typical place to search some CRDs are

- JSON schema store (very limited)

<https://www.schemastore.org/>

- yannh kubernetes schemas

This repository contains updated schemas for vanilla kubernetes resources and it is related with the kuberconform utility

<https://github.com/yannh/kubernetes-json-schema>

- Datree's CRDs catalog

Big online CRDs catalog

<https://github.com/datreeio/CRDs-catalog/>

- CRDs extractor

Datree offers a very interesting script called crd extractor that it search all the crds in a kubernetes cluster and it stores them as json under ~/.datree/crdSchemas/

<https://github.com/datreeio/CRDs-catalog/releases/latest/download/crd-extractor.zip>

- Official schema

Sometimes the developer offers a public json schema of their CRDs

### Examples

Here we can see how to associate public or downloaded json schemas with file names.

```json
    "yaml.schemas": {
        // Gitlab ci
        "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json": [".gitlab-ci.yml"],
        // MKdocs
        "https://json.schemastore.org/mkdocs-1.6.json": ["mkdocs.yml"],
        // Helm
        "https://json.schemastore.org/chart-lock.json" : "Chart.lock",
        "https://json.schemastore.org/chart.json": "Chart.yaml",
        // Argocd
        "https://raw.githubusercontent.com/datreeio/CRDs-catalog/refs/heads/main/argoproj.io/application_v1alpha1.json": ["argocd-app-*.yaml"],
        "file:///home/myuser/.datree/crdSchemas/argoproj.io/applicationset_v1alpha1.json": ["argocd-appset-*.yaml"],
        "file:///home/myuser/.datree/crdSchemas/argoproj.io/appproject_v1alpha1.json": ["argocd-proj-*.yaml"],
    },
```

> I prefer this way over the kubernetes microsoft extension
