# Convert RandomDataBase Subjects to Data Frame

Converts the list of `RandomSubject` objects stored in a
`RandomDataBase` instance into a data frame by applying `as.data.frame`
to each subject and binding the results by row.

## Usage

``` r
# S3 method for class 'RandomDataBase'
as.data.frame(x, ...)
```

## Arguments

- x:

  A `RandomDataBase` reference class object.

- ...:

  Additional arguments passed to `as.data.frame`.

## Value

A data frame containing all subjects from the database.

## See also

[`RandomDataBase`](https://RCONIS.github.io/randomforge/reference/RandomDataBase-class.md)
