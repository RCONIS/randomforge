# RandomResult Reference Class

Represents the outcome of a randomization, including treatment
assignment, system state, and method range set at the time of
randomization.

## Fields

- `uniqueId`:

  Character string uniquely identifying the randomization result.

- `randomizationDate`:

  POSIXct timestamp of the randomization.

- `treatmentArmId`:

  Character string indicating the assigned treatment arm.

- `randomSystemState`:

  `RandomSystemState` object representing the system state at
  randomization.

- `randomMethodRangeSet`:

  `RandomMethodRangeSet` object representing the method range set used.

## Methods

- initialize(..., randomizationDate = Sys.time()):

  Initializes a new `RandomResult` instance and assigns a unique ID.

- show(prefix = ""):

  Prints a summary of the randomization result.

- toString(prefix = ""):

  Returns a string representation of the randomization result.
