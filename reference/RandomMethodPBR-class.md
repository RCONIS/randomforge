# RandomMethodPBR Reference Class

Implements the Permuted Block Randomization (PBR) method, supporting
both fixed and randomized block designs for treatment allocation.

## Fields

- `name`:

  Character string specifying the method name.

- `uniqueId`:

  Character string uniquely identifying the method instance.

- `blockSizeRandomizer`:

  `RandomBlockSizeRandomizer` object for selecting block sizes randomly.

- `blockSizes`:

  List of block size configurations, each mapping treatment arm IDs to
  sizes.

- `fixedBlockDesignEnabled`:

  Logical indicating if a fixed block design is used.

- `fixedBlockIndex`:

  Integer specifying the index of the fixed block size to use.

## Methods

- initialize(...):

  Initializes a new `RandomMethodPBR` instance, validates block size
  settings, and assigns a unique ID.

- show():

  Prints a string representation of the method.

- toString():

  Returns a string representation of the method and its configuration.

- randomize(factorLevels, randomSystemState, randomAllocationValue):

  Performs randomization using PBR, updates system state, and returns a
  `RandomResult`.

- getNextRandomBlockSize():

  Retrieves the next block size configuration, either fixed or
  randomized.

## See also

[`getRandomMethodPBR()`](https://RCONIS.github.io/randomforge/reference/getRandomMethodPBR.md)
