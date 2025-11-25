# randomforge

**RandomForge — Innovating the Future of Randomization**

`randomforge` is an open, extensible framework for clinical trial
randomization methods in R.  
It provides a transparent and auditable core for implementing and using
randomization procedures, starting with a flexible implementation of
**permuted block randomization** and designed to grow into a broader
ecosystem of randomization methods.

This package is the core engine of the wider **RandomForge** initiative:
a community-driven effort to innovate the future of clinical trial
randomization.

## 🌍 Vision

Randomization is a cornerstone of clinical research integrity.  
Yet many tools currently in use are:

- proprietary and closed,
- difficult to extend or integrate,
- opaque in how assignments are generated,
- and not designed for collaborative innovation.

**RandomForge** aims to change this by providing an open, shared
infrastructure for randomization methods – where ideas can grow into
trusted, well-documented and practically usable methods, developed
together by the community.

## 🔧 Current Capabilities (0.1.x)

The current version of `randomforge` focuses on a robust core for
**permuted block randomization (PBR)**, built with extensibility in
mind.

Already implemented:

- **Permuted block randomization (PBR)** via
  [`getRandomMethodPBR()`](https://RCONIS.github.io/randomforge/reference/getRandomMethodPBR.md)
  - Support for *fixed* and *random* block sizes  
  - Support for *multi-arm* designs  
- **Configurable randomization projects**
  - [`getRandomProject()`](https://RCONIS.github.io/randomforge/reference/getRandomProject.md)
    to define a trial project  
  - [`getRandomConfiguration()`](https://RCONIS.github.io/randomforge/reference/getRandomConfiguration.md)
    to configure treatment arms, seeds and buffer sizes  
- **In-memory randomization database**
  - [`getRandomDataBase()`](https://RCONIS.github.io/randomforge/reference/getRandomDataBase.md)
    to manage projects, configurations, results and subjects  
  - S3 method
    [`as.data.frame.RandomDataBase()`](https://RCONIS.github.io/randomforge/reference/as.data.frame.RandomDataBase.md)
    to inspect randomized subjects
- **Stratification support at configuration and subject level**
  - Stratum identifiers are automatically constructed from named factor
    levels
- **Random allocation value service / buffer**
  - [`getRandomAllocationValueService()`](https://RCONIS.github.io/randomforge/reference/getRandomAllocationValueService.md)
    to manage the underlying random number stream
- **Excel export utilities**
  - [`writeExcelFile()`](https://RCONIS.github.io/randomforge/reference/writeExcelFile.md)
    to export randomization or subject lists into an Excel file
- **Helper utilities**
  - [`getTreatmentArmValueList()`](https://RCONIS.github.io/randomforge/reference/getTreatmentArmValueList.md)
    to construct arm-specific values, e.g. for allocation ratios or
    block compositions

The internal architecture uses reference classes to represent key
entities like `RandomProject`, `RandomConfiguration`, `RandomBlock`,
`RandomSubject`, and `RandomSystemState`. This makes it easier to extend
the engine to additional randomization methods in the future (e.g.,
covariate-adaptive or response-adaptive procedures).

## 🚀 Planned Extensions

While the current release focuses on permuted block randomization, the
RandomForge initiative is designed to cover a much wider range of
techniques over time, including (but not limited to):

- baseline-adaptive and covariate-adaptive methods (e.g. minimization),
- response-adaptive randomization,
- more advanced stratification & centre structures,
- enhanced auditing and reporting facilities,
- integration with Shiny UIs and web APIs,
- validation and documentation patterns suitable for regulated
  environments.

## 🧪 Example: Simple Block Randomization

The example below illustrates a minimal workflow using the currently
implemented PBR engine.  
It shows how to:

- create a project and configuration,
- choose a block randomization method,
- repeatedly request the next randomization result,
- inspect the resulting subject-level randomization in a data frame.

``` r
library(randomforge)

# Create an in-memory randomization database
randomDataBase <- getRandomDataBase()

# Define a project and configuration
randomProject <- getRandomProject("Example Trial")
randomDataBase$persist(randomProject)

# Create a randomization configuration
config <- getRandomConfiguration(
    randomProject        = randomProject,
    treatmentArmIds      = c("A", "B"),
    seed                 = createSeed(),
    ravBufferMinimumSize = 1000L,
    ravBufferMaximumSize = 10000L
)
config

randomDataBase$persist(config)

# Define variable block sizes
blockSizes <- getBlockSizes(config$treatmentArmIds, c(4, 6))

# Define a block randomization method
blockSizeRandomizer <- getRandomBlockSizeRandomizer(blockSizes)
blockSizeRandomizer

randomMethodPBR <- getRandomMethodPBR(
    blockSizes              = blockSizes,
    fixedBlockDesignEnabled = FALSE,
    blockSizeRandomizer     = blockSizeRandomizer
)

# Create a random allocation value service
ravService <- getRandomAllocationValueService()
ravService$createNewRandomAllocationValues(config)

# Visualize the distribution of the random allocation values
plot(ravService, usedValuesOnly = FALSE)

# Create a few randomization results
lapply(1:5, function(i) {
    getNextRandomResult(
        randomDataBase               = randomDataBase,
        randomProject                = randomProject,
        randomMethod                 = randomMethodPBR,
        randomAllocationValueService = ravService
    )
})

# Convert results to a data frame
as.data.frame(randomDataBase)
```

## 📦 Installation

At this stage, `randomforge` is not yet on CRAN. You can install the
development version from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("RCONIS/randomforge")
```
