# RandomMethodRangeSetPBR Reference Class

Extends `RandomMethodRangeSet` to support probability block
randomization, initializing ranges based on a `RandomBlock` object.

## Fields

- `Inherits`:

  all fields from `RandomMethodRangeSet`.

## Methods

- initialize(block, ...):

  Initializes a new `RandomMethodRangeSetPBR` instance using a
  `RandomBlock`. Validates the block and sets up ranges according to its
  probabilities.
