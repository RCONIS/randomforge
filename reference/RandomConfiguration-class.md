# RandomConfiguration Reference Class

Represents a randomization configuration for a project, including
treatment arms, seed, buffer sizes, and optional factor IDs. Provides
methods for initialization, display, and validation of configuration
parameters.

## Fields

- `uniqueId`:

  Character string uniquely identifying the configuration instance.

- `creationDate`:

  POSIXct timestamp of configuration creation.

- `randomProject`:

  `RandomProject` object associated with this configuration.

- `seed`:

  Integer random seed used for reproducibility.

- `ravBufferMinimumSize`:

  Integer specifying the minimum buffer size for allocation values.

- `ravBufferMaximumSize`:

  Integer specifying the maximum buffer size for allocation values.

- `treatmentArmIds`:

  Character vector of treatment arm IDs.

- `factorIds`:

  Character vector of factor IDs (optional).

## Methods

- initialize(..., creationDate, seed, ravBufferMinimumSize,
  ravBufferMaximumSize):

  Initializes a new `RandomConfiguration` instance, validates buffer
  sizes, assigns a unique ID, and sets the seed.

- show(prefix):

  Displays a summary of the configuration.

- toString(prefix):

  Returns a string representation of the configuration and its fields.

- getDoubleValue():

  Returns the double value (if defined).

- getSeed():

  Returns the seed value, validating its integrity.

## See also

[`getRandomConfiguration()`](https://RCONIS.github.io/randomforge/reference/getRandomConfiguration.md)
