# Create a New RandomBlockSizeRandomizer Instance

Constructs and returns a new `RandomBlockSizeRandomizer` reference class
object, which manages random selection of block sizes for randomization
procedures.

## Usage

``` r
getRandomBlockSizeRandomizer(blockSizes, ..., seed = NA_integer_)
```

## Arguments

- blockSizes:

  List of block size configurations, each mapping treatment arm IDs to
  sizes.

- ...:

  Additional arguments (currently unused).

- seed:

  Integer random seed used for reproducibility.

## Value

A `RandomBlockSizeRandomizer` reference class object.

## See also

[`RandomBlockSizeRandomizer`](https://RCONIS.github.io/randomforge/reference/RandomBlockSizeRandomizer-class.md)
