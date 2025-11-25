# Getting Started with randomforge

## Introduction

`randomforge` is an open-source R package providing a transparent and
modular framework for clinical trial randomization.  
This vignette gives a quick introduction on how to install the package,
create a simple project, configure a permuted block randomization
method, and generate subject allocations.

If you are new to randomization frameworks or want a minimal working
example, this is a good place to start.

## Installation

At this stage, `randomforge` is available only on GitHub:

``` r
# install.packages("remotes")
remotes::install_github("RCONIS/randomforge")
```

## Creating a Randomization Project

Every workflow begins with a `RandomProject` stored inside an in-memory
`RandomDataBase`:

``` r
library(randomforge)
#> randomforge developer version 0.1.0.9046 loaded

# Create an in-memory randomization database
randomDataBase <- getRandomDataBase()

# Define a project
randomProject <- getRandomProject("Example Trial")

# Store the project in the database
randomDataBase$persist(randomProject)
```

A project groups all configurations, subjects, and resulting
allocations.

## Defining a Randomization Configuration

A configuration defines:

- treatment arms  
- allocation parameters  
- random number buffer settings  
- seeds  
- optional stratification

Example:

``` r
config <- getRandomConfiguration(
    randomProject        = randomProject,
    treatmentArmIds      = c("A", "B"),
    seed                 = createSeed(),
    ravBufferMinimumSize = 1000L,
    ravBufferMaximumSize = 10000L
)
config
#> random-project: Example Trial [2025-11-25] dc3b6f8a-34d7-434b-9d6a-d2d7c5c041d0
#> uniqueId: a7c7e81f-df1d-491d-973b-53a98b49819d
#> creationDate: 2025-11-25
#> seed: 5536208
#> ravBufferMinimumSize: 1000
#> ravBufferMaximumSize: 10000
#> treatmentArmIds: 'A', 'B'

# Store the configuration
randomDataBase$persist(config)
```

## Creating a Block Randomization Method

`randomforge` currently supports **permuted block randomization** (PBR)
as a fully working implementation.

You can define variable block sizes:

``` r
# Define variable block sizes
blockSizes <- getBlockSizes(config$treatmentArmIds, c(4, 6))

# Define a block randomization method
blockSizeRandomizer <- getRandomBlockSizeRandomizer(blockSizes)
blockSizeRandomizer
#> RandomBlockSizeRandomizer(seed = 9560708, numberOfValues = 1000, currentIndex = 1)

randomMethodPBR <- getRandomMethodPBR(
    blockSizes              = blockSizes,
    fixedBlockDesignEnabled = FALSE,
    blockSizeRandomizer     = blockSizeRandomizer
)
```

## Create a Random Allocation Value Service

``` r
# Create a random allocation value service
ravService <- getRandomAllocationValueService()
ravService$createNewRandomAllocationValues(config)
#> Create 9000 new random allocation values (seed = 5536208)
```

Quality control of the random numbers used for randomization can be
visualized by

``` r
ravService |>
    plot(usedValuesOnly = FALSE)
```

![](randomforge_getting_started_files/figure-html/unnamed-chunk-6-1.png)

Other key performance indicators are planned for future releases.

## Running Randomization

To generate assignments, create a random allocation value service, then
call
[`getNextRandomResult()`](https://RCONIS.github.io/randomforge/reference/getNextRandomResult.md).

``` r
# Create a few randomization results
resultList <- lapply(1:12, function(i) {
    getNextRandomResult(
        randomDataBase               = randomDataBase,
        randomProject                = randomProject,
        randomMethod                 = randomMethodPBR,
        randomAllocationValueService = ravService
    ) |> suppressMessages()
})
```

``` r
ravService |>
    plot()
```

![](randomforge_getting_started_files/figure-html/unnamed-chunk-8-1.png)

## Inspecting the Results

All subjects and allocations stored in the database can be displayed as
a data frame:

``` r
# Convert results to a data frame
resultData <- randomDataBase |>
    as.data.frame()
resultData
```

| project       | random-number | treatment-arm | status     | overall-levels-A | overall-levels-B | block-wise-levels-A | block-wise-levels-B | randomization-decision                                        | unique-subject-id                    |
|:--------------|--------------:|:--------------|:-----------|-----------------:|-----------------:|:--------------------|:--------------------|:--------------------------------------------------------------|:-------------------------------------|
| Example Trial |             1 | A             | RANDOMIZED |                1 |                0 | A:1/3               | B:0/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.13261820236221\]   | 4a3f62a4-2c75-48b4-afa6-da79e2c9a889 |
| Example Trial |             2 | B             | RANDOMIZED |                1 |                1 | A:1/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.663016075268388\]  | 6521ef61-8c57-4e62-be94-66bf793ebdb8 |
| Example Trial |             3 | B             | RANDOMIZED |                1 |                2 | A:1/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.793864672072232\]  | 789578df-c98b-4c84-8fd9-b2ed4cfa9468 |
| Example Trial |             4 | B             | RANDOMIZED |                1 |                3 | A:1/3               | B:3/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.674710287945345\]  | 1785beb7-1ca9-4dde-ab23-2cbd46dd875e |
| Example Trial |             5 | A             | RANDOMIZED |                2 |                3 | A:2/3               | B:3/3               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.273352156858891\]      | 733eed8e-d277-463d-9049-15fb65d4adc9 |
| Example Trial |             6 | A             | RANDOMIZED |                3 |                3 | A:3/3               | B:3/3               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.642791367368773\]      | 640dbac5-10d5-4c40-a286-bc644721ea51 |
| Example Trial |             7 | A             | RANDOMIZED |                4 |                3 | A:1/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.486639296170324\]  | 74464f66-5ece-4216-ae21-e810014540a1 |
| Example Trial |             8 | A             | RANDOMIZED |                5 |                3 | A:2/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.278875668765977\]  | cf701007-44e5-4ced-a36e-60c117777e17 |
| Example Trial |             9 | B             | RANDOMIZED |                5 |                4 | A:2/2               | B:1/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.950392527040094\]      | 822d2a9a-b52a-40a2-8fb6-a173323cb7a0 |
| Example Trial |            10 | B             | RANDOMIZED |                5 |                5 | A:2/2               | B:2/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.127482084790245\]      | a5a66d57-8576-4922-b010-cfdd5abdb9d5 |
| Example Trial |            11 | A             | RANDOMIZED |                6 |                5 | A:1/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0077078144531697\] | 788d13e0-a034-42a8-ad2a-5da652a3ec57 |
| Example Trial |            12 | B             | RANDOMIZED |                6 |                6 | A:1/2               | B:1/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.515290598617867\]  | edcde683-786c-48da-9477-58e7cae9ab61 |

## Exporting to Excel (Optional)

`randomforge` supports exporting subject lists or randomization results
via
[`writeExcelFile()`](https://RCONIS.github.io/randomforge/reference/writeExcelFile.md):

``` r
writeExcelFile(resultData, "randomization_list.xlsx")
```

## What’s Next?

The project is in an early phase, and many extensions are planned:

- covariate-adaptive methods (e.g., minimization)
- response-adaptive techniques  
- stratified and center-based workflows  
- audit trail and reporting components  
- Shiny and API integration

To learn how to contribute, see the vignette:

**[`vignette("randomforge_contribution")`](https://RCONIS.github.io/randomforge/articles/randomforge_contribution.md)**

## Thank You

We hope this vignette helps you get started with `randomforge`.  
Feedback and suggestions are very welcome via GitHub issues.
