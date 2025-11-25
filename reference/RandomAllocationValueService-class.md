# RandomAllocationValueService Reference Class

Manages the generation and retrieval of random allocation values for
randomization procedures. Maintains a reproducible sequence of random
values using a seed, and provides methods for initialization, value
creation, retrieval, and display.

## Fields

- `seed`:

  Integer random seed used for reproducibility.

- `index`:

  Integer index tracking the current position in the values vector.

- `values`:

  Numeric vector of generated random allocation values.

## Methods

- initialize(...):

  Initializes the service, setting the seed, index, and values.

- show():

  Displays a summary of the service.

- toString():

  Returns a string representation of the service.

- createNewRandomAllocationValues(randomConfiguration):

  Generates new random allocation values based on the configuration.

- getNextRandomAllocationValue(randomConfiguration):

  Retrieves the next random allocation value if available.

## See also

[`plot()`](https://RCONIS.github.io/randomforge/reference/plot.RandomAllocationValueService.md)
