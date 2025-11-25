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
#> random-project: Example Trial [2025-11-25] 183096e6-c340-4ab5-a472-3cdf001b9fdd
#> uniqueId: 8fd8f0a6-d8d7-494a-a85e-9a4f9dc673ac
#> creationDate: 2025-11-25
#> seed: 1906864
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
#> RandomBlockSizeRandomizer(seed = 5214430, numberOfValues = 1000, currentIndex = 1)

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
#> Create 9000 new random allocation values (seed = 1906864)
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
| Example Trial |             1 | B             | RANDOMIZED |                0 |                1 | A:0/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.931215447140858\]  | 7d2144e8-53f9-4e48-878b-7fd1510f35f0 |
| Example Trial |             2 | A             | RANDOMIZED |                1 |                1 | A:1/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.151349758263677\]  | 28ad48c2-d4a9-42cc-b6dc-91d280a2312d |
| Example Trial |             3 | A             | RANDOMIZED |                2 |                1 | A:2/3               | B:1/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.389427364105359\]  | 078009a4-a0cf-4130-bc44-24549c5926ef |
| Example Trial |             4 | B             | RANDOMIZED |                2 |                2 | A:2/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.544316260842606\]  | b344df1a-b456-4210-ac58-c799acad4d1f |
| Example Trial |             5 | A             | RANDOMIZED |                3 |                2 | A:3/3               | B:2/3               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.243480938486755\]  | ad2f2597-3eb4-40e2-a989-0851f1ce481e |
| Example Trial |             6 | B             | RANDOMIZED |                3 |                3 | A:3/3               | B:3/3               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.976979868952185\]      | bc155a91-afe8-457a-8161-a70e35112d77 |
| Example Trial |             7 | A             | RANDOMIZED |                4 |                3 | A:1/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0951676818076521\] | 26a3097f-debf-4122-b3e6-9ddb2f12e168 |
| Example Trial |             8 | A             | RANDOMIZED |                5 |                3 | A:2/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.382600583136082\]  | acfc312d-0220-405a-941a-bea7ee3896d3 |
| Example Trial |             9 | B             | RANDOMIZED |                5 |                4 | A:2/2               | B:1/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.133505923673511\]      | c9321e52-8005-4e3d-a719-de7262184f1c |
| Example Trial |            10 | B             | RANDOMIZED |                5 |                5 | A:2/2               | B:2/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.841252446640283\]      | c424cabe-6387-42a0-beda-15275d9f8a19 |
| Example Trial |            11 | B             | RANDOMIZED |                5 |                6 | A:0/2               | B:1/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.707709337817505\]  | 0e536cf8-bb1a-4b8d-a5cd-794c91757719 |
| Example Trial |            12 | B             | RANDOMIZED |                5 |                7 | A:0/2               | B:2/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.505966184427962\]  | 084a8abb-6483-4942-923e-b1e0d99f96be |

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
