# Labels and annotations

## Labels

### Workflow creator

<https://argo-workflows.readthedocs.io/en/stable/workflow-creator/>

### Configmap

- Executor plugin

```txt
workflows.argoproj.io/configmap-type: ExecutorPlugin
```

<https://argo-workflows.readthedocs.io/en/stable/executor_plugins/>

- Memoization and cache

```txt
workflows.argoproj.io/configmap-type: Cache
```

- Parameter

<https://argo-workflows.readthedocs.io/en/stable/memoization/>

```txt
workflows.argoproj.io/configmap-type: Parameter
```

## Annotations

### Title and description

```txt
workflows.argoproj.io/title: "My title"
```

defaults to metadata.name if not specified

```txt
workflows.argoproj.io/description: "SuperDuperProject"
```

<https://argo-workflows.readthedocs.io/en/stable/title-and-description/>
