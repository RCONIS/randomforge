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
#> random-project: Example Trial [2025-11-25] bffa647f-3556-4b64-b50e-e0648ee07e6d
#> uniqueId: 16754915-5742-40ac-9662-9a805eb45831
#> creationDate: 2025-11-25
#> seed: 1313197
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
#> RandomBlockSizeRandomizer(seed = 9987514, numberOfValues = 1000, currentIndex = 1)

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
#> Create 9000 new random allocation values (seed = 1313197)
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

| project       | random-number | treatment-arm | status     | overall-levels-A | overall-levels-B | block-wise-levels-A | block-wise-levels-B | randomization-decision                                         | unique-subject-id                    |
|:--------------|--------------:|:--------------|:-----------|-----------------:|-----------------:|:--------------------|:--------------------|:---------------------------------------------------------------|:-------------------------------------|
| Example Trial |             1 | B             | RANDOMIZED |                0 |                1 | A:0/2               | B:1/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.629477623617277\]   | 533fc011-a83a-42e0-8898-4300982f4061 |
| Example Trial |             2 | B             | RANDOMIZED |                0 |                2 | A:0/2               | B:2/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.97752565308474\]    | 28a273a0-9ff7-4996-8dba-7114ea92bce8 |
| Example Trial |             3 | A             | RANDOMIZED |                1 |                2 | A:1/2               | B:2/2               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.92538466420956\]        | 8f073594-1cbe-4ed1-9fdd-77a19e85e079 |
| Example Trial |             4 | A             | RANDOMIZED |                2 |                2 | A:2/2               | B:2/2               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.982598439324647\]       | cc461c4b-64a9-4208-b3bd-ca3290cea5fa |
| Example Trial |             5 | A             | RANDOMIZED |                3 |                2 | A:1/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.329277870245278\]   | 9413edaa-201c-4f1a-9169-52e9cca77eb8 |
| Example Trial |             6 | A             | RANDOMIZED |                4 |                2 | A:2/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0123300880659372\]  | 2e6f69de-4df4-4bb8-9289-a17b64964f66 |
| Example Trial |             7 | B             | RANDOMIZED |                4 |                3 | A:2/2               | B:1/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.193724269978702\]       | 5662bc04-ffa3-423b-a37e-b1d1365e189c |
| Example Trial |             8 | B             | RANDOMIZED |                4 |                4 | A:2/2               | B:2/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.87234138767235\]        | 4e369e81-479d-4a29-81ce-a13250962e52 |
| Example Trial |             9 | A             | RANDOMIZED |                5 |                4 | A:1/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0796789808664471\]  | 7b2400ec-09b2-472d-8b1d-8844808cb992 |
| Example Trial |            10 | A             | RANDOMIZED |                6 |                4 | A:2/2               | B:0/2               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.00596604868769646\] | 47faf660-286f-4d03-87f6-6baf07044204 |
| Example Trial |            11 | B             | RANDOMIZED |                6 |                5 | A:2/2               | B:1/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.558540755882859\]       | 0da2f80a-1e19-4921-a672-a0261f84852a |
| Example Trial |            12 | B             | RANDOMIZED |                6 |                6 | A:2/2               | B:2/2               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.757488034199923\]       | ba96323e-0ad6-4f42-96d6-eea9f14498c7 |

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
