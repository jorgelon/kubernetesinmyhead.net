# Intro

## How it works

Ytt is a command line tool useful for template an patch yaml files. For that purpose, it uses some diferent document types

## Templated

A templated document in ytt is any YAML file that uses ytt's templating syntax (#@) to create dynamic, configurable Kubernetes manifests or other YAML output. Here is where we define the final yaml file.

> They do not start with an specific anotation, but they have template logic inside.

## Data value

A data value a ytt document that contains the values that the templates can use.

> It is very similar to a values.yaml files in helm but in this case can be validated against a schema

- <https://carvel.dev/ytt/docs/latest/how-to-use-data-values/>
- <https://carvel.dev/ytt/docs/latest/ytt-data-values/>

## Data Value Schema

A data value schema is a ytt document where we define things for the data values documents:

- the expected structure. the shape of complex data structures
- the default values for optional fields
- types (string, int, bool, etc)
- validation rules

When providing data values, ytt validates them against this schema to see if the values provided are correct.

- <https://carvel.dev/ytt/docs/latest/lang-ref-ytt-schema/>
- <https://carvel.dev/ytt/docs/latest/how-to-write-validations/>
- <https://carvel.dev/ytt/docs/latest/schema-validations-cheat-sheet/>

## Overlay

An Overlay Document in ytt is a document that modifies or patches existing YAML documents by applying transformations, additions, deletions, or replacements. It's marked with the #@overlay/match annotation and allows you to make targeted changes to other documents.

- <https://carvel.dev/ytt/docs/latest/ytt-overlays/>
- <https://carvel.dev/ytt/docs/latest/lang-ref-ytt-overlay/>

## Table and annotations

| Type              | Annotation                       | Purpose               |
|-------------------|----------------------------------|-----------------------|
| Templated         | contains lines with #@           |                       |
| Data Values       | begins with #@data/values        | provide values        |
| Data Value Schema | begins with #@data/values-schema | data value validation |
| Overlay           | begins with @overlay/match       |                       |
| Plain             | No annotations                   |                       |

## Conclusions

In ytt we define template documents with the estructure and logic of the final yaml files we want.

We give them values using data value documents, that can be validated against data value schema documents.

We can use overlay documents to modify final output without modifying original templates, for example, adding or removing sections.

## Links

- Data Values vs Overlays

<https://carvel.dev/ytt/docs/latest/data-values-vs-overlays/>
