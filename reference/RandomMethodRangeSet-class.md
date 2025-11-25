# RandomMethodRangeSet Reference Class

Represents a set of randomization method ranges, each associated with a
treatment arm and probability, and provides methods for initialization,
validation, and lookup.

## Fields

- `uniqueId`:

  Character string uniquely identifying the range set.

- `ranges`:

  List of `RandomMethodRange` objects, keyed by treatment arm ID.

- `randomAllocationDoubleValue`:

  Numeric value representing the last allocation value used.

## Methods

- initialize(ranges = list(), ...):

  Initializes a new `RandomMethodRangeSet` instance and assigns a unique
  ID.

- show():

  Prints a string representation of the range set.

- toString():

  Returns a string representation of the range set.

- getRange(treatmentArmId):

  Retrieves the range for a specified treatment arm.

- indexOf(randomAllocationValue):

  Finds the treatment arm for a given allocation value.

- initRanges(probabilities):

  Initializes ranges based on a named list of probabilities.

- validate():

  Validates that the ranges are contiguous and sum to 1.0.
