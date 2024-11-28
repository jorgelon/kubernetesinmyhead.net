# Templates

The templates are functions than can be called in argo workflows. There are several template types, and they are defined here:

```yaml
spec:
  templates:
    - name: my-template
      TYPEOFTEMPLATE:
```

## Template callers

There are 2 special template types called template callers or template invocators. They really call other "normal" templates with some additional logic

- Steps

In the "steps" template caller you can define a list of tasks to be executed sequentially or in parallel. Also another options are available.

- Dag

The "dag" template invocator executes other normal templates using dependencies between them

## Template

- Container

The most simple template type. It defines a container image with command and args like in a kubernetes pod.

- Script

Same as container but it add a "source" field where you can define a script to be executed. The result is saved in an variable.

- Containerset

It defines some containers to be executed in the same pod. An important thing is that they can share empty-dir volumes.

- Resource

This template permits to do actions in kubernetes resources (get, create, apply, delete, replace, or patch resources on your cluster)

- Http
This template does a http call to an endpoint

- Data

This template permits to transform a source of data.

- Suspend

Permits to suspend the execution of the workflow. It can be resumed manually or after a defined duration.

## Links

<https://argo-workflows.readthedocs.io/en/stable/workflow-concepts/>
