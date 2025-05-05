# Ways to call a (cluster)workflowtemplate

## Call the whole template with workflowTemplateRef

We can create a workflow specifying a (cluster)workflowtemplate to be launched using spec.workflowTemplateRef. We can also provider parameters where that they will be passed to the entrypoint.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: myworkflow-
spec:
  workflowTemplateRef:
    name: myclusterworkflowtemplate
    clusterScope: true # this calls a clusterworkflowtemplate. If false or ommited (default), it calls a workflowtemplate
  arguments:
    parameters:
      - name: message
        value: "Hello, world!"
```

No template inside the the (cluster)workflowtemplate is selected. The default one will be used and it will receive the parameters.

In the UI

![alt text](default.png)

We cannot use spec.templates if we are using spec.workflowTemplateRef. This throws an error

```txt
Templates is invalid field in spec if workflow referred WorkflowTemplate reference
```

## From a task or step with templateRef

We can invoke a (cluster)workflowtemplate from a task or step defined in a dag or steps template using templateRef.
In this case we must choose what template will be chosen form the (cluster)workflowtemplate as entrypoint.

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: myworkflow-
spec:
  entrypoint: main
  templates:
    - name: main
      dag:
        tasks:
          - name: main
            templateRef:
              name: myclusterworkflowtemplate # this calls a clusterworkflowtemplate. If false or ommited (default), it calls a workflowtemplate
              template: whalesay # choose the desired template from the (cluster)workflowtemplate
              clusterScope: true
            arguments:
              parameters:
                - name: message
                  value: "Hello from task"
```

In the UI

![alt text](ep.png)
