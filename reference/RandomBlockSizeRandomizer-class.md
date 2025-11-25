# RandomBlockSizeRandomizer Reference Class

Manages random selection of block sizes for randomization procedures.
Maintains a reproducible sequence of block sizes using a seed, and
provides methods for initialization, value generation, and retrieval.

## Fields

- `seed`:

  Integer random seed used for reproducibility.

- `values`:

  Integer vector of randomly generated block sizes.

- `index`:

  Integer index tracking the current position in the values vector.

## Methods

- initialize(seed, ...):

  Initializes the randomizer with a seed and sets the index to 1.

- show():

  Displays a summary of the randomizer.

- toString():

  Returns a string representation of the randomizer.

- initRandomValues(numberOfBlockSizes, numberOfValuesToCreate):

  Generates a sequence of random block sizes.

- nextInt(numberOfBlockSizes):

  Retrieves the next random block size from the sequence.

## See also

[`getRandomBlockSizeRandomizer()`](https://RCONIS.github.io/randomforge/reference/getRandomBlockSizeRandomizer.md)
