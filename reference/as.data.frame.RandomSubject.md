# Convert RandomSubject to Data Frame

Converts a `RandomSubject` object into a data frame containing project,
random number, treatment arm, status, system state, randomization
decision, and unique subject ID.

## Usage

``` r
# S3 method for class 'RandomSubject'
as.data.frame(x, ...)
```

## Arguments

- x:

  A `RandomSubject` object.

- ...:

  Additional arguments (currently unused).

## Value

A data frame with columns for subject and randomization details.

## See also

[`RandomSubject`](https://RCONIS.github.io/randomforge/reference/RandomSubject-class.md)
