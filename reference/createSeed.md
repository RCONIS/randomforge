# Create Seed

Returns one or more true random numbers which can be used as seed.

## Usage

``` r
createSeed(numberOfValues = 1, minValue = 1e+06, maxValue = 9999999, ...)
```

## Arguments

- numberOfValues:

  a single integer value. Number of seeds to create, default is `1`.

- minValue:

  a single integer value. The minimum value that a seed can have,
  default is `1000000`.

- maxValue:

  a single integer value. The maximum value that a seed can have,
  default is `9999999`.

- ...:

  optional arguments.

## Value

an integer value or vector containing one or more seeds.

## Details

RANDOM.ORG offers true random numbers to anyone on the Internet. The
randomness comes from atmospheric noise, which for many purposes is
better than the pseudo-random number algorithms typically used in
computer programs. For more information see <https://www.random.org>.
