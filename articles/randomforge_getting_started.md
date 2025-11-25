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
#> random-project: Example Trial [2025-11-25] c18746d0-950b-4fc4-8011-e6d0115afb3e
#> uniqueId: db5c2e91-3141-4535-8b9d-7678e79206ce
#> creationDate: 2025-11-25
#> seed: 9423579
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
#> RandomBlockSizeRandomizer(seed = 8403360, numberOfValues = 1000, currentIndex = 1)

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
#> Create 9000 new random allocation values (seed = 9423579)
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

| project       | random-number | treatment-arm | status     | overall-levels-A | overall-levels-B | block-wise-levels-A | block-wise-levels-B | randomization-decision                                       | unique-subject-id                    |
|:--------------|--------------:|:--------------|:-----------|-----------------:|-----------------:|:--------------------|:--------------------|:-------------------------------------------------------------|:-------------------------------------|
| Example Trial |             1 | B             | RANDOMIZED |                0 |                1 | A:0/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.889369842829183\] | ace91735-cbd0-4a8f-a256-a019e890d999 |
| Example Trial |             2 | A             | RANDOMIZED |                1 |                1 | A:1/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.488860014127567\] | 0c781066-acad-4b27-859b-99c33a289151 |
| Example Trial |             3 | B             | RANDOMIZED |                1 |                2 | A:1/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.8212684399914\]   | 9ccb4fd0-3cff-4430-a50a-5808ee5eb5d6 |
| Example Trial |             4 | A             | RANDOMIZED |                2 |                2 | A:2/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.478498306591064\] | 7fa70873-a0b0-492c-9cc8-109869e9661e |
| Example Trial |             5 | B             | RANDOMIZED |                2 |                3 | A:2/3               | B:3/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.741877030581236\] | ace4db41-f96a-47ad-a2e5-6ef92e731127 |
| Example Trial |             6 | A             | RANDOMIZED |                3 |                3 | A:3/3               | B:3/3               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.813621209235862\]     | b39bd500-5207-41a8-b561-236c08d5008c |
| Example Trial |             7 | B             | RANDOMIZED |                3 |                4 | A:0/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.886986121535301\] | 55c7ce3b-32ac-459a-8567-dab9ef610f9c |
| Example Trial |             8 | B             | RANDOMIZED |                3 |                5 | A:0/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.815402401145548\] | 0557fb2d-4389-41aa-9ffc-08da13ac656f |
| Example Trial |             9 | A             | RANDOMIZED |                4 |                5 | A:1/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.309202764183283\] | 705cc113-fc92-4cef-9076-305423864007 |
| Example Trial |            10 | B             | RANDOMIZED |                4 |                6 | A:1/3               | B:3/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.804697354091331\] | 3fd5f259-d0d4-4ecc-aa24-958e75f04f08 |
| Example Trial |            11 | A             | RANDOMIZED |                5 |                6 | A:2/3               | B:3/3               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.26038038986735\]      | f39fb2e6-5142-4f7e-acca-d94fb8c4dc43 |
| Example Trial |            12 | A             | RANDOMIZED |                6 |                6 | A:3/3               | B:3/3               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.00869782222434878\]   | 31a241ed-18d0-4e8f-8380-32332bceab4d |

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
