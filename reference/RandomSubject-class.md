# RandomSubject Reference Class

Represents a subject in the randomization system, including unique
identifier, project association, random number, factor levels,
randomization result, and status.

## Fields

- `uniqueId`:

  Character string uniquely identifying the subject.

- `randomProject`:

  `RandomProject` object associated with the subject.

- `randomNumber`:

  Integer representing the subject's random number.

- `factorLevels`:

  List of factor levels for the subject.

- `randomResult`:

  `RandomResult` object containing the randomization outcome.

- `status`:

  Character string indicating the subject's status.

## Methods

- initialize(...):

  Initializes a new `RandomSubject` instance and assigns a unique ID.

- show(prefix = ""):

  Prints a summary of the subject.

- toString(prefix = ""):

  Returns a string representation of the subject.

- setStatus(status):

  Sets the subject's status.

## See also

[`as.data.frame()`](https://RCONIS.github.io/randomforge/reference/as.data.frame.RandomSubject.md)
