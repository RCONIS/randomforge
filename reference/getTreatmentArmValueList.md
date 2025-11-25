# Generate Named List of Treatment Arm Values

Creates a named list of treatment arm values from variable arguments,
ensuring the correct number of values per treatment arm. Handles block
size logic for balanced randomization.

## Usage

``` r
getTreatmentArmValueList(..., treatmentArmIds)
```

## Arguments

- ...:

  Values or block size for treatment arms.

- treatmentArmIds:

  Character vector of treatment arm identifiers.

## Value

A named list of treatment arm values.
