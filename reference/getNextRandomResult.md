# Generate and Persist the Next Randomization Result

Retrieves the next random allocation value, generates a new
randomization result using the specified method, updates the system
state, and persists all relevant objects in the database.

## Usage

``` r
getNextRandomResult(
  randomDataBase,
  randomProject,
  randomMethod,
  randomAllocationValueService
)
```

## Arguments

- randomDataBase:

  Object providing access to randomization data and persistence methods.

- randomProject:

  `RandomProject` reference class object representing the current
  project.

- randomMethod:

  Object implementing the randomization method with a `randomize`
  function.

- randomAllocationValueService:

  Service object for managing random allocation values.

## Value

A `RandomResult` reference class object representing the outcome of the
randomization.

## Details

Validates the project, retrieves configuration and allocation values,
manages system state, and persists the result and subject information.
