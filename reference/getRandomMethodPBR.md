# Create a Permuted Block Randomization Method Instance

Constructs and returns a new `RandomMethodPBR` reference class object,
configured for permuted block randomization with specified block sizes
and design options.

## Usage

``` r
getRandomMethodPBR(
  ...,
  blockSizes = list(),
  fixedBlockDesignEnabled = TRUE,
  fixedBlockIndex = 1L,
  blockSizeRandomizer = NULL
)
```

## Arguments

- ...:

  Additional arguments passed to the `RandomMethodPBR` initializer.

- blockSizes:

  List of block size configurations, each mapping treatment arm IDs to
  sizes.

- fixedBlockDesignEnabled:

  Logical indicating if a fixed block design is used (default: TRUE).

- fixedBlockIndex:

  Integer specifying the index of the fixed block size to use (default:
  1).

- blockSizeRandomizer:

  `RandomBlockSizeRandomizer` object for selecting block sizes randomly.

## Value

A `RandomMethodPBR` reference class object.

## See also

[`RandomMethodPBR`](https://RCONIS.github.io/randomforge/reference/RandomMethodPBR-class.md)
