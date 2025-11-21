# randomforge

**RandomForge — Innovating the Future of Randomization**

`randomforge` is an open, extensible framework for clinical trial
randomization methods in R.  
It provides a transparent and auditable core for implementing and using
randomization procedures, starting with a flexible implementation of
**permuted block randomization** and designed to grow into a broader ecosystem
of randomization methods.

This package is the core engine of the wider **RandomForge** initiative:
a community-driven effort to innovate the future of clinical trial
randomization.

---

## 🌍 Vision

Randomization is a cornerstone of clinical research integrity.  
Yet many tools currently in use are:

- proprietary and closed,
- difficult to extend or integrate,
- opaque in how assignments are generated,
- and not designed for collaborative innovation.

**RandomForge** aims to change this by providing an open, shared infrastructure
for randomization methods – where ideas can grow into trusted, well-documented
and practically usable methods, developed together by the community.

---

## 🔧 Current Capabilities (0.1.x)

The current version of `randomforge` focuses on a robust core for
**permuted block randomization (PBR)**, built with extensibility in mind.

Already implemented:

- **Permuted block randomization (PBR)** via `getRandomMethodPBR()`  
  - Support for *fixed* and *random* block sizes  
  - Support for *multi-arm* designs  
- **Configurable randomization projects**  
  - `getRandomProject()` to define a trial project  
  - `getRandomConfiguration()` to configure treatment arms, seeds and buffer sizes  
- **In-memory randomization database**  
  - `getRandomDataBase()` to manage projects, configurations, results and subjects  
  - S3 method `as.data.frame.RandomDataBase()` to inspect randomized subjects
- **Stratification support at configuration and subject level**  
  - Stratum identifiers are automatically constructed from named factor levels
- **Random allocation value service / buffer**  
  - `getRandomAllocationValueService()` to manage the underlying random number stream
- **Excel export utilities**  
  - `writeExcelFile()` to export randomization or subject lists into an Excel file
- **Helper utilities**  
  - `getTreatmentArmValueList()` to construct arm-specific values, e.g. for
    allocation ratios or block compositions

The internal architecture uses reference classes to represent key entities like
`RandomProject`, `RandomConfiguration`, `RandomBlock`, `RandomSubject`, and
`RandomSystemState`. This makes it easier to extend the engine to additional
randomization methods in the future (e.g., covariate-adaptive or
response-adaptive procedures).

---

## 🚀 Planned Extensions

While the current release focuses on permuted block randomization, the
RandomForge initiative is designed to cover a much wider range of techniques
over time, including (but not limited to):

- baseline-adaptive and covariate-adaptive methods (e.g. minimization),
- response-adaptive randomization,
- more advanced stratification & centre structures,
- enhanced auditing and reporting facilities,
- integration with Shiny UIs and web APIs,
- validation and documentation patterns suitable for regulated environments.

---

## 🧪 Example: Simple Block Randomization

The example below illustrates a minimal workflow using the currently
implemented PBR engine.  
It shows how to:

- create a project and configuration,
- choose a block randomization method,
- repeatedly request the next randomization result,
- inspect the resulting subject-level randomization in a data frame.

```r
library(randomforge)

# 1) Create a randomization project
random_db <- getRandomDataBase()
project   <- getRandomProject("Example Trial")

# 2) Define a randomization configuration
#    Here: two treatment arms "A" and "B"
config <- getRandomConfiguration(
    randomProject        = project,
    treatmentArmIds      = c("A", "B"),
    seed                 = 123L,
    ravBufferMinimumSize = 1000L,
    ravBufferMaximumSize = 10000L
)

# Persist configuration in the in-memory database
random_db$persist(config)

# 3) Define a permuted block randomization (PBR) method
#    - here with variable block sizes of 4 and 6
block_size_randomizer <- getRandomBlockSizeRandomizer()
method_pbr <- getRandomMethodPBR(
    blockSizes              = list(4L, 6L),
    fixedBlockDesignEnabled = FALSE,
    blockSizeRandomizer     = block_size_randomizer
)

# 4) Create an allocation value service (random number buffer)
rav_service <- getRandomAllocationValueService()

# 5) Draw a couple of randomization results
results <- vector("list", 10L)
for (i in seq_along(results)) {
    # factorLevels can be used for stratification; here left empty (no strata)
    results[[i]] <- getNextRandomResult(
        randomDataBase               = random_db,
        randomProject                = project,
        randomMethod                 = method_pbr,
        randomAllocationValueService = rav_service
    )
}

# 6) Inspect the randomized subjects as a data frame
df_subjects <- as.data.frame(random_db)
head(df_subjects)
```

## 📦 Installation

At this stage, `randomforge` is not yet on CRAN.
You can install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("RCONIS/randomforge")
```
