# RandomMethodRange Reference Class

Represents a range for randomization methods, associated with a
treatment arm and defined by lower and upper bounds.

## Fields

- `uniqueId`:

  Character string uniquely identifying the method range.

- `treatmentArmId`:

  Character string specifying the treatment arm.

- `lowerBound`:

  Numeric value for the lower bound of the range.

- `upperBound`:

  Numeric value for the upper bound of the range.

## Methods

- initialize(..., treatmentArmId, lowerBound, upperBound):

  Initializes a new `RandomMethodRange` instance and assigns a unique
  ID.

- show():

  Prints a string representation of the method range.

- toString(randomAllocationValue = NULL):

  Returns a string representation of the range, optionally including a
  specific allocation value.

- contains(value):

  Checks if a value falls within the defined range.
