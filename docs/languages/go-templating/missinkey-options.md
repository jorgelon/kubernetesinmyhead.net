# Missing key options

Control the behavior during execution if a map is indexed with a key that is not present in the map.

## missingkey=default / "missingkey=invalid"

The default behavior: Do nothing and continue execution.
If printed, the result of the index operation is the string  "NO VALUE".

## missingkey=zero

 The operation returns the zero value for the map type's element.

## missingkey=error

 Execution stops immediately with an error.
