# Data values

If we want to create a template or schema that can be called via data values, we can start our schema file this

```yaml
#@ load("@ytt:data", "data")
---
```

This imports the the "data" struct from the @ytt:data module

## Declaring data values

A data value declaration has 3 parts: a name, a default value, and a type.

```yaml
this-is-the-name: this-is-the-default-value
map:
  integer: 45323
  boolean: true
array:
- default-empty-string: ""
  boolean: false
```

Or it can be called via data values

```yaml
name: #@ data.values.name
```

## Schema validations
