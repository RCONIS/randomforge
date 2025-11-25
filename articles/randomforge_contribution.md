# Contributing to randomforge

## Introduction

**RandomForge — An Open Project for Clinical Trial Randomization in R**

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

## 1. Installing randomforge and running a simple randomization

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
    blockSizes              = blockSizes,
    fixedBlockDesignEnabled = FALSE
)

# Create a random allocation value service
ravService <- getRandomAllocationValueService()
ravService$createNewRandomAllocationValues(config)
#> Create 9000 new random allocation values (seed = 6692687)

# Create a few randomization results
resultList <- lapply(1:8, function(i) {
    getNextRandomResult(
        randomDataBase               = randomDataBase,
        randomProject                = randomProject,
        randomMethod                 = randomMethodPBR,
        randomAllocationValueService = ravService
    )
})
#> Get next random result (rav:0.254686910891905)...
#> Randomize using PBR...
#> Get block...
#> Create new block...
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Random result: random-result[treatment:A, overall-levels[A:1, B:0], block-wise-levels[A:1/4, B:0/4], range-set[A=[0,0.5], B=[0.5,1]; rav=0.254686910891905]]
#> Get next random result (rav:0.732571959961206)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Random result: random-result[treatment:B, overall-levels[A:1, B:1], block-wise-levels[A:1/4, B:1/4], range-set[A=[0,0.5], B=[0.5,1]; rav=0.732571959961206]]
#> Get next random result (rav:0.491432298207656)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Random result: random-result[treatment:A, overall-levels[A:2, B:1], block-wise-levels[A:2/4, B:1/4], range-set[A=[0,0.5], B=[0.5,1]; rav=0.491432298207656]]
#> Get next random result (rav:0.0196517161093652)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Random result: random-result[treatment:A, overall-levels[A:3, B:1], block-wise-levels[A:3/4, B:1/4], range-set[A=[0,0.5], B=[0.5,1]; rav=0.0196517161093652]]
#> Get next random result (rav:0.342846009880304)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Init ranges via probabilities A = 0.5, B = 0.5
#> Random result: random-result[treatment:A, overall-levels[A:4, B:1], block-wise-levels[A:4/4, B:1/4], range-set[A=[0,0.5], B=[0.5,1]; rav=0.342846009880304]]
#> Get next random result (rav:0.782142449636012)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0, B = 1
#> Init ranges via probabilities A = 0, B = 1
#> Random result: random-result[treatment:B, overall-levels[A:4, B:2], block-wise-levels[A:4/4, B:2/4], range-set[A=[0,0], B=[0,1]; rav=0.782142449636012]]
#> Get next random result (rav:0.709863466676325)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0, B = 1
#> Init ranges via probabilities A = 0, B = 1
#> Random result: random-result[treatment:B, overall-levels[A:4, B:3], block-wise-levels[A:4/4, B:3/4], range-set[A=[0,0], B=[0,1]; rav=0.709863466676325]]
#> Get next random result (rav:0.124208028428257)...
#> Randomize using PBR...
#> Get block...
#> Use existing block...
#> Init ranges via probabilities A = 0, B = 1
#> Init ranges via probabilities A = 0, B = 1
#> Random result: random-result[treatment:B, overall-levels[A:4, B:4], block-wise-levels[A:4/4, B:4/4], range-set[A=[0,0], B=[0,1]; rav=0.124208028428257]]

# Convert results to a data frame
randomDataBase |> 
    as.data.frame() |>
    knitr::kable()
```

| project       | random-number | treatment-arm | status     | overall-levels-A | overall-levels-B | block-wise-levels-A | block-wise-levels-B | randomization-decision                                        | unique-subject-id                    |
|:--------------|--------------:|:--------------|:-----------|-----------------:|-----------------:|:--------------------|:--------------------|:--------------------------------------------------------------|:-------------------------------------|
| Example Trial |             1 | A             | RANDOMIZED |                1 |                0 | A:1/4               | B:0/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.254686910891905\]  | cf9f3aaf-5722-44d8-a081-9b7104d87abe |
| Example Trial |             2 | B             | RANDOMIZED |                1 |                1 | A:1/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.732571959961206\]  | b92bfedc-a492-45ea-bf67-92aec9e67fa8 |
| Example Trial |             3 | A             | RANDOMIZED |                2 |                1 | A:2/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.491432298207656\]  | a7642527-d963-486d-92db-0c8743a24737 |
| Example Trial |             4 | A             | RANDOMIZED |                3 |                1 | A:3/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.0196517161093652\] | ffe6807b-843e-45b2-809d-94d9177f5318 |
| Example Trial |             5 | A             | RANDOMIZED |                4 |                1 | A:4/4               | B:1/4               | range-set\[A=\[0,0.5\], B=\[0.5,1\]; rav=0.342846009880304\]  | a955d411-4ddc-49ed-b156-feec91b12f60 |
| Example Trial |             6 | B             | RANDOMIZED |                4 |                2 | A:4/4               | B:2/4               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.782142449636012\]      | 6f37b9fe-b34e-4018-a561-751e81f4ee9a |
| Example Trial |             7 | B             | RANDOMIZED |                4 |                3 | A:4/4               | B:3/4               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.709863466676325\]      | 861b9fbe-091d-4320-99f9-7b689008b8e9 |
| Example Trial |             8 | B             | RANDOMIZED |                4 |                4 | A:4/4               | B:4/4               | range-set\[A=\[0,0\], B=\[0,1\]; rav=0.124208028428257\]      | 96618a3d-2ca7-4127-a920-2054a8abb3be |

## 2. How to contribute to randomforge

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

## 3. Option A: Get invited as a direct contributor

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

## 4. Option B: Contribute via Fork (recommended for most users)

If you are not familiar with GitHub contribution workflows, here is a
simple step-by-step guide.

### Step 1 — Create a GitHub account

If you do not already have one, register at  
<https://github.com>

### Step 2 — Open the randomforge repository

Navigate to:  
<https://github.com/RCONIS/randomforge>

### Step 3 — Click “Fork”

The button is in the upper-right corner.  
This creates *your own copy* of the repository under your GitHub
account.

### Step 4 — Clone your fork to your local machine

``` bash
git clone https://github.com/YOUR_USERNAME/randomforge.git
```

Then:

``` bash
cd randomforge
```

### Step 5 — Create a new branch for your change

``` bash
git checkout -b my-feature-branch
```

### Step 6 — Make your changes locally

Edit R files, documentation, tests, examples, or vignettes.

### Step 7 — Commit your changes

``` bash
git add .
git commit -m "Add new feature / fix / improvement"
```

### Step 8 — Push your branch to your fork

``` bash
git push origin my-feature-branch
```

### Step 9 — Open a Pull Request

Go back to your fork on GitHub and click:

**“Compare & pull request”**

In the Pull Request description, please provide:

- a brief explanation of your change  
- any related issue numbers  
- optional: screenshots or examples

We will review all contributions as soon as possible.

## 5. Getting help

If you get stuck at any point — GitHub workflow, code questions,
architecture discussion — feel free to:

- open an issue in the GitHub repository, or  
- send an email to: **<friedrich.pahlke@rpact.com>**

All questions are welcome, especially from newcomers.  
We want to make contributing as easy and friendly as possible.

## 6. Thank you

We appreciate your interest in contributing to the RandomForge
project.  
Your ideas and contributions help shape a more open, transparent, and
community-driven future for clinical trial randomization in R.
