# RandomAllocationValue Reference Class

Represents a single random allocation value, including its unique
identifier, configuration, creation date, numeric value, associated
result, and hash. Provides methods for initialization, display, string
conversion, and value retrieval.

## Fields

- `uniqueId`:

  Character unique identifier for the allocation value.

- `randomConfiguration`:

  `RandomConfiguration` object describing the randomization setup.

- `creationDate`:

  POSIXct timestamp of creation.

- `doubleValue`:

  Numeric value representing the allocation.

- `randomResult`:

  `RandomResult` object associated with the allocation.

- `hashValue`:

  Integer hash of the allocation value.

## Methods

- initialize(..., creationDate = Sys.time()):

  Initializes a new `RandomAllocationValue` instance, setting the
  creation date and generating a unique ID.

- show(prefix = ""):

  Displays a summary of the allocation value.

- toString(prefix = ""):

  Returns a string representation of the allocation value.

- getDoubleValue():

  Returns the numeric allocation value.
