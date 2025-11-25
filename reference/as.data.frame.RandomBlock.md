# Convert RandomBlock Arms to Data Frame

Converts the list of `RandomBlockArm` objects stored in a `RandomBlock`
instance into a data frame by applying `.treatmentListToDataFrame` to
the block arms.

## Usage

``` r
# S3 method for class 'RandomBlock'
as.data.frame(x, ...)
```

## Arguments

- x:

  A `RandomBlock` reference class object.

- ...:

  Additional arguments passed to the conversion function.

## Value

A data frame containing all block arms from the block.

## See also

[`RandomBlock`](https://RCONIS.github.io/randomforge/reference/RandomBlock-class.md)
