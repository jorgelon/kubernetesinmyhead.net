# Naming

Naming is the process where we define how the metric will be exposed. The naming is done using the "name" field and permits to convert a prometheus metric intro a custom metric and viceversa. We have 2 fields here:

- matches

With the "matches" field we define a pattern to select a prometheus metric using a regular expression.

- as:

With the "as" field we transform the metric in another.

> Default: With no "as" field, if the matches field does not contain capture groups, the default will be $0. If it containes a single capture group the default will be $1.

```yaml
# this turns any name <name>_total to <name>_per_second
name:
  matches: "^(.*)_total$"
  as: "${1}_per_second"
```
