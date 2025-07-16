# Control structures

## If

- Checks if a value is non-empty (not zero, not nil, not false, not empty string/slice/map).
- If the value is present and non-empty, executes the block.
- If the value is missing and missingkey=error is set, it will error.

```yaml
{{- if .ignoreDifferences }}
ignoreDifferences:
{{ toYaml .ignoreDifferences | nindent 4 }}
{{- end }}
```

## With

- Checks if a value exists and is non-empty.

- If it exists, enters the block and sets . (dot) to that value inside the block.

- If the value is missing, the block is skipped without error, even with missingkey=error.

```yaml
{{- with .ignoreDifferences }}
ignoreDifferences:
{{ toYaml . | nindent 4 }}
{{- end }}
```

## Range

Pending
