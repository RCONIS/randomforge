# RandomSystemState Reference Class

Represents the state of a randomization system, tracking filling levels
for treatment arms across overall, block, stratum, and factor levels.

## Details

`fillingLevelsBlock`: Contains the filling levels of each treatment arm
respectively inside each block, where a block exists for each stratum.  
  

Example: B = 6

- RandomBlock 1 (gender: male)
  - Treatment 1 = 2
  - Treatment 2 = 2
  - Treatment 3 = 2
- RandomBlock 2 (gender: female)
  - Treatment 1 = 2
  - Treatment 2 = 1
  - Treatment 3 = 2

  
  

Data format:
`Map(key = 'block id' = 'strata id', value = 'treatment filling level')`.

`fillingLevelsStratum`:

Contains the filling levels of each treatment arm respectively inside
each stratum.  
  

Example:

- Gender: male
  - Treatment 1 = 5
  - Treatment 2 = 5
  - Treatment 3 = 3
- Gender: female
  - Treatment 1 = 4
  - Treatment 2 = 4
  - Treatment 3 = 5

  
  

Data format:
`Map(key = 'strata id', value = 'treatment filling level')`.

`fillingLevelsFactor`:

Contains the filling levels of each treatment arm respectively inside
each factor level.  
  

Example:

- Gender: male
  - Treatment 1 = 5
  - Treatment 2 = 5
  - Treatment 3 = 3
- Gender: female
  - Treatment 1 = 4
  - Treatment 2 = 4
  - Treatment 3 = 5

  
  

Data format:
`Map(key = 'factor level id', value = 'treatment filling level')`.

## Fields

- `uniqueId`:

  Character string uniquely identifying the system state.

- `fillingLevelsOverall`:

  List of overall filling levels for each treatment arm.

- `blocks`:

  List of block objects for each stratum.

- `fillingLevelsBlock`:

  List of filling levels for each treatment arm within each block.

- `fillingLevelsBlockMaximum`:

  List of maximum filling levels for each treatment arm within each
  block.

- `fillingLevelsStratum`:

  List of filling levels for each treatment arm within each stratum.

- `fillingLevelsFactor`:

  List of filling levels for each treatment arm within each factor
  level.

## Methods

- initialize(...):

  Initializes a new `RandomSystemState` instance.

- show(prefix = ""):

  Prints a summary of the system state.

- toString(prefix = ""):

  Returns a string representation of the system state.

- init(treatmentArmIds, ..., factorIds = NULL, strataIds = NULL):

  Initializes filling levels for treatment arms, factors, and strata.

- clone():

  Creates a deep copy of the system state.

- getBlock(factorLevels, randomBlockSizeGenerator):

  Retrieves or creates a block for the given factor levels.

- incrementFillingLevel(treatmentArmId):

  Increments the overall filling level for a treatment arm.

- setFillingLevelsBlock(randomBlock):

  Sets the filling levels for a block.

## See also

[`as.data.frame()`](https://RCONIS.github.io/randomforge/reference/as.data.frame.RandomSystemState.md)
