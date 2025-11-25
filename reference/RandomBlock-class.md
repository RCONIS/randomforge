# RandomBlock Reference Class

Represents a block of treatment arms for randomization, with associated
factor levels (strata). Provides methods for initialization, cloning,
display, validation, probability calculation, and block arm management.

## Arguments

- treatmentArmIds:

  the treatment arm id's.

- maximumBlockSize:

  the maximum block length `B` for each treatment arm.

- factorLevels:

  the optional factors and factor levels.

## Fields

- `blockArms`:

  List mapping treatment arm IDs to `RandomBlockArm` objects.

- `factorLevels`:

  List of strata and their levels, where keys are factor names or IDs
  and values are specific levels (name or ID).

## Methods

- initialize(..., maximumBlockSize, currentBlockSize, blockArms,
  factorLevels):

  Initializes a new `RandomBlock` instance, optionally setting up block
  arms and factor levels.

- clone():

  Creates a deep copy of the block and its arms.

- show():

  Displays a summary of the block.

- toString():

  Returns a string representation of the block and its arms.

- assertBlockArmsAreValid():

  Validates that block arms are present and non-empty.

- isCompleted():

  Checks if all block arms are completed.

- getProbabilities():

  Returns a list of allocation probabilities for each treatment arm.

- incrementSize(treatmentArmId):

  Increments the size of the specified block arm.

- getBlockArm(treatmentArmId):

  Retrieves the block arm for a given treatment arm ID.

- keySet():

  Returns the set of treatment arm IDs.

- get(key):

  Retrieves the block arm by key.

- getTreatmentCount():

  Returns the number of treatment arms.

- init(maximumBlockSize, currentBlockSize, factorLevels):

  Initializes block arms and factor levels.

## See also

[`as.data.frame()`](https://RCONIS.github.io/randomforge/reference/as.data.frame.RandomBlock.md)
