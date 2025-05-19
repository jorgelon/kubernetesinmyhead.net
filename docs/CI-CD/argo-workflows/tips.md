# Tips

## Template names

- Don't use hypens "-" in template names. Some times they can cause errors

- Don't use uppercase letters in template names. They will be the name of the pod and that is not permitted.

## Annotations

We can configure the title and description in the argo workflows dashboard with this annotations

- workflows.argoproj.io/title
- workflows.argoproj.io/description

## was unable to obtain the node

The following error can be ignored

```txt
... level=warning msg="was unable to obtain the node for XXXX, taskName XXXX"
```

More info here <https://github.com/argoproj/argo-workflows/issues/12382>
