# RandomDataBase Reference Class

Manages randomization data, including projects, configurations,
allocation values, subjects, and results. Provides methods for
validation, persistence, retrieval, and display of randomization
objects.

## Fields

- `uniqueId`:

  Character string uniquely identifying the database instance.

- `creationDate`:

  POSIXct timestamp of database creation.

- `randomProjects`:

  List of `RandomProject` objects.

- `randomConfigurations`:

  List of `RandomConfiguration` objects.

- `randomAllocationValues`:

  List of `RandomAllocationValue` objects.

- `randomSubjects`:

  List of `RandomSubject` objects.

- `randomResults`:

  List of `RandomResult` objects.

## Methods

- initialize(..., creationDate):

  Initializes a new `RandomDataBase` instance, assigns a unique ID, and
  sets up empty lists for all fields.

- validateRandomProject(randomProject):

  Checks if a project exists in the database; stops with an error if
  not.

- show():

  Displays a summary of the database and its contents.

- toString():

  Returns a string representation of the database and its statistics.

- persist(obj):

  Persists an object to the appropriate list based on its class.

- getRandomProjectUniqueIds(objects):

  Returns a character vector of unique IDs for the given objects'
  projects.

- getLastSubject(randomProject):

  Retrieves the last subject for a given project.

- getLastRandomConfiguration(randomProject):

  Retrieves the last configuration for a given project.

- createNewSubjectRandomNumber(randomProject):

  Generates the next subject random number for a given project.

## See also

[`getRandomDataBase()`](https://RCONIS.github.io/randomforge/reference/getRandomDataBase.md)

[`as.data.frame()`](https://RCONIS.github.io/randomforge/reference/as.data.frame.RandomDataBase.md)
