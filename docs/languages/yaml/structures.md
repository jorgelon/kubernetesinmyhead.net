# YAML Data Structures

## Lists / Arrays

A list can be represented in two ways.

Block style (multi-line format):

```yaml
fruits:
  - apple
  - banana
  - cherry
```

Abbreviated (inline) style:

```yaml
fruits: ["apple", "banana", "cherry"]
```

Empty list:

```yaml
containers: []
```

Block style also supports a standalone list without a key:

```yaml
- Apple
- Orange
- Strawberry
- Mango
```

By using the block style, you can make the array more readable, especially when
dealing with longer lists or more complex structures.

## Maps / Dictionaries

A dictionary can be represented in two ways.

Block style (multi-line format):

```yaml
martin:
  name: Martin D'vloper
  job: Developer
  skill: Elite
```

Abbreviated (inline) style:

```yaml
martin: {name: Martin D'vloper, job: Developer, skill: Elite}
```

Empty dictionary:

```yaml
podSelector: {}
```

## Empty Notations

In YAML, `{}` and `[]` are shorthand notations for empty objects and empty
arrays, respectively:

- `{}` - **Empty Object (Dictionary)**: Represents an empty key-value structure.
  For example, `podSelector: {}` selects all pods.
- `[]` - **Empty Array (List)**: Represents an empty list.
  For example, `containers: []` means no containers are defined.

**Key Differences**:

- `{}` is used for objects (dictionaries) with key-value pairs.
- `[]` is used for arrays (lists) of items.

## Block Scalars

Block scalars let you include multi-line strings. The chomping indicator
controls how trailing newlines are handled:

- `|` — Literal block: preserves newlines, keeps one trailing newline.
- `|-` — Literal block with strip chomping: removes all trailing newlines.
- `|+` — Literal block with keep chomping: preserves all trailing newlines.
- `>` — Folded block: newlines are replaced with spaces (except blank lines).

```yaml
example1: |
  This is a block scalar.
  It preserves newlines.

example2: |-
  This is a block scalar.
  It strips trailing newlines.

example3: |+
  This is a block scalar.
  It keeps trailing newlines.
```

Folded scalar example:

```yaml
description: >
  This is a block of text.
  Newlines are replaced with spaces.
```

## Links

- <https://yaml.org/spec/1.2.2/>
- <https://yaml-multiline.info/>
- <https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html>
