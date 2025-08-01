# Overlay

An Overlay Document in ytt is a document that modifies or patches existing YAML documents by applying transformations, additions, deletions, or replacements. It's marked with the #@overlay/match annotation and allows you to make targeted changes to other documents.

Purpose:

- Modify existing documents: Change specific fields or sections
- Add new content: Insert additional fields, containers, or resources
- Remove content: Delete unwanted fields or sections
- Replace values: Override specific values in targeted documents
- Conditional modifications: Apply changes based on conditions

```yaml
#@overlay/match by=overlay.subset({"kind": "Deployment"})
---
spec:
  #@overlay/match missing_ok=True
  template:
    spec:
      containers:
      #@overlay/match by="name"
      - name: app
        #@overlay/replace
        image: nginx:1.22
        #@overlay/insert
        env:
        - name: DEBUG
          value: "true"
```

Common overlay operations:

- @overlay/match: Select which documents/fields to modify
- @overlay/replace: Replace the entire value
- @overlay/insert: Add new fields or array items
- @overlay/remove: Delete fields or array items
- @overlay/append: Add to the end of arrays
- @overlay/merge: Merge objects together

Use cases:

- Environment-specific changes: Different configs for dev/staging/prod
- Feature toggles: Enable/disable features conditionally
- Security patches: Add security contexts or policies
- Resource adjustments: Modify CPU/memory limits per environment
- Multi-tenancy: Customize base templates per tenant

How it works:

- Target selection: Uses match criteria to find documents to modify
- Transformation: Applies the specified changes (replace, insert, remove, etc.)
- Output: Produces the modified YAML with changes applied

In summary: An overlay document is ytt's way of applying targeted patches or modifications to existing YAML documents, enabling flexible customization without duplicating entire templates.
