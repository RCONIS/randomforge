# RandomProject Reference Class

Represents a randomization project, including a unique identifier,
project name, and creation date.

## Fields

- `uniqueId`:

  Character string uniquely identifying the project.

- `name`:

  Character string specifying the project name.

- `creationDate`:

  POSIXct timestamp of project creation.

## Methods

- initialize(..., creationDate = Sys.time()):

  Initializes a new `RandomProject` instance and assigns a unique ID.

- show(prefix = ""):

  Prints a summary of the project.

- toString(prefix = ""):

  Returns a string representation of the project.

## See also

[`getRandomProject()`](https://RCONIS.github.io/randomforge/reference/getRandomProject.md)
