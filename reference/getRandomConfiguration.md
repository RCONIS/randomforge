# Create a New RandomConfiguration Instance

Constructs and returns a new `RandomConfiguration` reference class
object, initializing all fields and assigning a unique ID. Allows
specification of treatment arms, seed, buffer sizes, and associated
project.

## Usage

``` r
getRandomConfiguration(
  ...,
  randomProject,
  treatmentArmIds,
  seed = NA_integer_,
  ravBufferMinimumSize = 1000L,
  ravBufferMaximumSize = 10000L
)
```

## Arguments

- ...:

  Additional arguments passed to the constructor.

- randomProject:

  `RandomProject` object associated with this configuration.

- treatmentArmIds:

  Character vector of treatment arm IDs.

- seed:

  Integer random seed used for reproducibility. Defaults to
  `NA_integer_`.

- ravBufferMinimumSize:

  Integer specifying the minimum buffer size for allocation values.
  Defaults to `1000L`.

- ravBufferMaximumSize:

  Integer specifying the maximum buffer size for allocation values.
  Defaults to `10000L`.

## Value

A `RandomConfiguration` reference class object.

## See also

[`RandomConfiguration`](https://RCONIS.github.io/randomforge/reference/RandomConfiguration-class.md)
