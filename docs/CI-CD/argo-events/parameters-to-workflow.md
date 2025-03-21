# Pass parameters to workflows

We can trigger an argo workflow with argo events and pass parameters

```yaml
    - template:
        name: argo-workflow-trigger
        conditions: mycondition
        policy:
          k8s:
            labels:
              workflows.argoproj.io/phase: Succeeded
        k8s:  # I have found some problems using "argoWorkflow:" here
          operation: create
          ...
          parameters:
            - src:
                dependencyName: mydependency
                dataKey: body.fistparameter
              dest: spec.arguments.parameters.0.value ## this will be the first parameter in the workflow
            - src:
                dependencyName: mydependency
                dataKey: body.another
              dest: spec.arguments.parameters.1.value ## this will be the second parameter in the workflow
            - src:
                dependencyName: mydependency
                dataKey: body.mytitle
              dest: metadata.annotations.workflows\.argoproj.io\/title # we can escape characters
            - src:
                dependencyName: mydependency
                dataKey: body.mydescription
              dest: metadata.annotations.workflows\.argoproj\.io\/description # we can escape characters

```
