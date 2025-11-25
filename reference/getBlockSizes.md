# Get Block Sizes for Treatment Arms

Generates a list of block sizes per treatment arm for specified
treatment arms and total block sizes. Each block size per treatment arm
is computed according to the provided allocation fraction or defaults to
equal allocation if not specified.

## Usage

``` r
getBlockSizes(treatmentArmIds, blockSizes, allocationFraction = NA_real_)
```

## Arguments

- treatmentArmIds:

  Character vector of treatment arm identifiers.

- blockSizes:

  Integer vector specifying the total block sizes to use. If more than
  one block size is provided, variable block sizes will be used.

- allocationFraction:

  Numeric vector specifying the allocation fraction for each treatment
  arm. Defaults to equal allocation if `NA`.

## Value

A list of block allocations, each represented as a named list of counts
per treatment arm.

## Examples

``` r
# variable block sizes with 1:1 allocation ratio
getBlockSizes(c("A", "B"), c(4, 6))
#> [[1]]
#> [[1]]$A
#> [1] 2
#> 
#> [[1]]$B
#> [1] 2
#> 
#> 
#> [[2]]
#> [[2]]$A
#> [1] 3
#> 
#> [[2]]$B
#> [1] 3
#> 
#> 

# fixed block size with 2:1 allocation ratio
getBlockSizes(c("A", "B"), 9, c(2/3, 1/3))
#> [[1]]
#> [[1]]$A
#> [1] 6
#> 
#> [[1]]$B
#> [1] 3
#> 
#> 
```
