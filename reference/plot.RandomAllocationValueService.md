# Plot Distribution of Random Allocation Values

Visualizes the distribution of random allocation values managed by a
`RandomAllocationValueService` object. Optionally restricts the plot to
only used values and performs a chi-squared test for uniformity.

## Usage

``` r
# S3 method for class 'RandomAllocationValueService'
plot(x, ..., usedValuesOnly = TRUE)
```

## Arguments

- x:

  A `RandomAllocationValueService` object.

- ...:

  Additional arguments passed to the `hist` function.

- usedValuesOnly:

  Logical; if `TRUE`, only values up to the current index are plotted.

## Value

A histogram plot of the random allocation values.
