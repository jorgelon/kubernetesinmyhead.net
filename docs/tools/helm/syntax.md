# Syntax

<https://helm.sh/docs/chart_template_guide/function_list/>
<https://helm.sh/docs/chart_template_guide/control_structures/>
if/else
with
range
define
template
block

<https://helm.sh/docs/chart_template_guide/yaml_techniques/>
<https://helm.sh/docs/chart_template_guide/data_types/>

<https://helm.sh/docs/chart_best_practices/templates/>

## {{-  and -}}

{{- (with the dash and space added) indicates that whitespace should be chomped left
-}} means whitespace to the right should be consumed.
Be careful! Newlines are whitespace!

## :=

In Helm charts, the := operator is used in the Go templating language to assign a value to a variable.
{{- $myVar := .Values.myValue -}}
you can use $myVar in your template to refer to the value of .Values.myValue.

Please note that the scope of variables in Helm templates can be complex, and the := operator creates a variable that is only available in the scope where it is defined.
