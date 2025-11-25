# Contributing to randomforge

## Introduction

**randomforge — An Open Project for Clinical Trial Randomization in R**

`randomforge` is a newly started, open-source project on GitHub that
aims to provide a clean and transparent implementation of clinical trial
randomization methods in R. The initial version focuses on a flexible
and modular implementation of **permuted block randomization**, with the
goal of gradually expanding the framework to additional techniques.

The project is still in an early phase, but it is designed to be openly
accessible and easy to extend. Contributions, discussions, and feedback
from statisticians, programmers, and clinical trial practitioners are
explicitly welcome as the project evolves.

This vignette explains how to:

1.  Install and try the package with a small reproducible example  
2.  Contribute to the project  
3.  Use GitHub effectively even if you are new to it

## Installing randomforge and running a simple randomization

At this stage, the package is not yet on CRAN.  
You can install the development version directly from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("RCONIS/randomforge")
```

Below is a minimal example that demonstrates a simple permuted block
randomization workflow.

``` r
library(randomforge)
#> randomforge developer version 0.1.0.9046 loaded

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

randomDataBase$persist(config)

# Define fixed block size
blockSizes <- getBlockSizes(config$treatmentArmIds, 8)

# Create a permuted block randomization method
randomMethodPBR <- getRandomMethodPBR(
    blockSizes = blockSizes
)

# Create a random allocation value service
ravService <- getRandomAllocationValueService()
ravService$createNewRandomAllocationValues(config)
#> Create 9000 new random allocation values (seed = 8850860)

# Create a few randomization results
resultList <- lapply(1:8, function(i) {
    suppressMessages(getNextRandomResult(
        randomDataBase               = randomDataBase,
        randomProject                = randomProject,
        randomMethod                 = randomMethodPBR,
        randomAllocationValueService = ravService
    ))
})

# Convert results to a data frame
randomDataBase |> 
    as.data.frame() |>
    knitr::kable()
```

| project       | random-number | treatment-arm | status     | overall-levels-A | overall-levels-B | block-wise-levels-A | block-wise-levels-B | randomization-decision                                        | unique-subject-id                    |
|:--------------|--------------:|:--------------|:-----------|-----------------:|-----------------:|:--------------------|:--------------------|:--------------------------------------------------------------|:-------------------------------------|
| Example Trial |             1 | B             | RANDOMIZED |                0 |                1 | A:0/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.683325938181952\]  | f08f72ee-5fb6-445f-8d51-ba521c79fa68 |
| Example Trial |             2 | A             | RANDOMIZED |                1 |                1 | A:1/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.381664458895102\]  | 08f28ed8-3855-4148-9e09-3fd38a6f745b |
| Example Trial |             3 | B             | RANDOMIZED |                1 |                2 | A:1/4               | B:2/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.535462300293148\]  | 29a66399-1188-4846-95be-82006c915a12 |
| Example Trial |             4 | A             | RANDOMIZED |                2 |                2 | A:2/4               | B:2/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0398822568822652\] | 016c8ce2-3cdc-4d1b-9556-e8295a909036 |
| Example Trial |             5 | B             | RANDOMIZED |                2 |                3 | A:2/4               | B:3/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.534922601422295\]  | a9d790fe-d53e-48da-b652-989be45e3896 |
| Example Trial |             6 | A             | RANDOMIZED |                3 |                3 | A:3/4               | B:3/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.257961915340275\]  | 4d3d2a4f-2521-4641-9d48-fedcb0ee1340 |
| Example Trial |             7 | B             | RANDOMIZED |                3 |                4 | A:3/4               | B:4/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.923591203056276\]  | d760137e-cca8-4da5-931f-cbcab791e30d |
| Example Trial |             8 | A             | RANDOMIZED |                4 |                4 | A:4/4               | B:4/4               | range-set\[A=\[0,1\], B=\[1,1\]; rav=0.571475161937997\]      | d853c942-971c-4889-b0dc-fc177dcb103e |

## How to contribute to randomforge

Contributions of all kinds are welcome:

- new randomization methods  
- improvements to the existing code  
- better documentation  
- tests and reproducible examples  
- fixing typos or cleaning up style  
- suggesting new functionality

You do **not** need to be an expert in R, Git, or clinical trial
methodology to get involved.  
We are happy to support new contributors.

### Option A: Get invited as a direct contributor

If you prefer not to deal with forks or pull requests, you can simply
request to be added as a contributor to the GitHub repository.

Please send an email to:

**<friedrich.pahlke@rpact.com>**

with a brief note explaining:

- who you are  
- your GitHub username  
- why you would like to contribute

Once added, you will be able to push branches and open pull requests
directly in the main repository.

### Option B: Contribute via Fork (recommended for most users)

If you are not familiar with GitHub contribution workflows, here is a
simple step-by-step guide.

#### Step 1 — Create a GitHub account

If you do not already have one, register at  
<https://github.com>

#### Step 2 — Open the randomforge repository

Navigate to:  
<https://github.com/RCONIS/randomforge>

#### Step 3 — Click “Fork”

The button is in the upper-right corner.  
This creates *your own copy* of the repository under your GitHub
account.

#### Step 4 — Clone your fork to your local machine

``` bash
git clone https://github.com/YOUR_USERNAME/randomforge.git
```

Then:

``` bash
cd randomforge
```

#### Step 5 — Create a new branch for your change

``` bash
git checkout -b my-feature-branch
```

#### Step 6 — Make your changes locally

Edit R files, documentation, tests, examples, or vignettes.

#### Step 7 — Commit your changes

``` bash
git add .
git commit -m "Add new feature / fix / improvement"
```

#### Step 8 — Push your branch to your fork

``` bash
git push origin my-feature-branch
```

#### Step 9 — Open a Pull Request

Go back to your fork on GitHub and click:

**“Compare & pull request”**

In the Pull Request description, please provide:

- a brief explanation of your change  
- any related issue numbers  
- optional: screenshots or examples

We will review all contributions as soon as possible.

## Getting help

If you get stuck at any point — GitHub workflow, code questions,
architecture discussion — feel free to:

- open an issue in the GitHub repository, or  
- send an email to: **<friedrich.pahlke@rpact.com>**

All questions are welcome, especially from newcomers.  
We want to make contributing as easy and friendly as possible.

## Thank you

We appreciate your interest in contributing to the **randomforge**
project.  
Your ideas and contributions help shape a more open, transparent, and
community-driven future for clinical trial randomization in R.
