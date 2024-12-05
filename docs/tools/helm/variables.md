# Helm variables

Helm provides a set of built-in variables that you can use in your Helm templates. These variables are automatically populated by Helm and can be used to customize your Kubernetes manifests. Here is a list of some common Helm variables:

## Release Information

```txt
{{ .Release.Name }}: The name of the release.
{{ .Release.Namespace }}: The namespace to which the release is deployed.
{{ .Release.IsUpgrade }}: True if the current operation is an upgrade.
{{ .Release.IsInstall }}: True if the current operation is an install.
{{ .Release.Revision }}: The revision number of the release.
{{ .Release.Service }}: The service rendering the template. (usually helm)
```

## Chart Information

```txt
{{ .Chart.Name }}: The name of the chart.
{{ .Chart.Version }}: The version of the chart.
{{ .Chart.AppVersion }}: The app version of the chart.
{{ .Chart.Description }}: The description of the chart.
```

## Values

```txt
{{ .Values }}: The values passed into the chart.
{{ .Values.<key> }}: Access a specific value from the values file.
```

## Files

```txt
{{ .Files }}: Access non-template files in the chart.
{{ .Files.Get "<file>" }}: Get the contents of a file.
{{ .Files.GetBytes "<file>" }}: Get the contents of a file as bytes.
```

## Capabilities

```txt
{{ .Capabilities.APIVersions.Has "batch/v1" }}: Check if a specific API version is available.
{{ .Capabilities.KubeVersion.GitVersion }}: The Kubernetes version.
{{ .Capabilities.KubeVersion.Major }}: The major version of Kubernetes.
{{ .Capabilities.KubeVersion.Minor }}: The minor version of Kubernetes.
```

## Template Information

```txt

{{ .Template.Name }}: The name of the template file being rendered.
```

## Links

- Built-in Objects

<https://helm.sh/docs/chart_template_guide/builtin_objects/>
