# RandomBlockArm Reference Class

Represents a treatment arm within a randomization block, tracking its
allocation status and limits. Provides methods for initialization,
cloning, display, size management, and completion checks.

## Fields

- `treatmentArmId`:

  Character ID of the treatment arm.

- `maximumSize`:

  Integer specifying the maximum allowed allocations for this arm.

- `.self$currentSize`:

  Integer tracking the current number of allocations.

- `enabled`:

  Logical indicating if the arm is active for allocation.

## Methods

- initialize(treatmentArmId, maximumSize, ..., .self\$currentSize = 0L,
  enabled = TRUE):

  Initializes a new `RandomBlockArm` instance.

- clone():

  Creates a deep copy of the block arm.

- show():

  Displays a summary of the block arm.

- toString():

  Returns a string representation of the block arm.

- incrementSize():

  Increments the current allocation size, with validation.

- isCompleted():

  Checks if the arm has reached its maximum allocation or is disabled.

- getCurrentSize():

  Returns the current allocation size.

- getMaximumSize():

  Returns the maximum allocation size.
