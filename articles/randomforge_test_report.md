# randomforge Test Report

## Introduction

Welcome to the “randomforge Test Report” vignette. This document
provides a comprehensive overview of the testing results for the
randomforge project. The tests are executed using the
[testthat](https://cran.r-project.org/package=testthat) package, and the
results are summarized with the
[covrpage](https://github.com/yonicd/covrpage) package.

In this vignette, you can expect to find:

- **Summarized Test Results**: Short and long summaries of the test
  results, highlighting any failures or issues encountered.
- **Detailed Test Results**: An expandable section with detailed
  information on each test, including any errors or failures.
- **Session Information**: Information about the R session and the
  packages used during testing.

This report aims to provide a clear and detailed account of the testing
process and results, ensuring transparency and aiding in the
identification and resolution of any issues.

## Summarized Test Results

| file                                                                                                                          |   n |   time | error | failed | skipped | warning |
|:------------------------------------------------------------------------------------------------------------------------------|----:|-------:|------:|-------:|--------:|--------:|
| [test_f_seed.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test_f_seed.R)                                 |  10 |  1.071 |     0 |      0 |       0 |       0 |
| [test-class_random_data_base.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test-class_random_data_base.R) | 766 | 12.473 |     0 |      0 |       0 |       0 |
| [test-f_random_block_size.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test-f_random_block_size.R)       |  11 |  0.108 |     0 |      0 |       0 |       0 |

Show Detailed Test Results

| file                                                                                                                              | context                | test                                                                   | status |   n |   time |
|:----------------------------------------------------------------------------------------------------------------------------------|:-----------------------|:-----------------------------------------------------------------------|:-------|----:|-------:|
| [test_f_seed.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test_f_seed.R#L27_L28)                             | f_seed                 | For invalid input arguments ‘createSeed’ throws meaningful exceptions  | PASS   |   4 |  0.182 |
| [test_f_seed.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test_f_seed.R#L41)                                 | f_seed                 | The results of ‘createSeed’ depend on the input arguments as expected  | PASS   |   4 |  0.873 |
| [test_f_seed.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test_f_seed.R#L53_L56)                             | f_seed                 | ‘createSeed’ returns valid seed although network connection is missing | PASS   |   2 |  0.016 |
| [test-class_random_data_base.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test-class_random_data_base.R#L55) | class_random_data_base | Test that seed is working as expected                                  | PASS   | 766 | 12.473 |
| [test-f_random_block_size.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test-f_random_block_size.R#L25)       | f_random_block_size    | Test block size assertions                                             | PASS   |   5 |  0.050 |
| [test-f_random_block_size.R](https://github.com/RCONIS/randomforge/blob/main/tests/testthat/test-f_random_block_size.R#L39)       | f_random_block_size    | Test block size generation and validation                              | PASS   |   6 |  0.058 |

Session Info

| Field    | Value                        |                                                                                                                                                                                             |
|:---------|:-----------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Version  | R version 4.5.2 (2025-10-31) |                                                                                                                                                                                             |
| Platform | x86_64-pc-linux-gnu          | [![](https://github.com/metrumresearchgroup/covrpage/blob/actions/inst/logo/gh.png?raw=true)](https://github.com/RCONIS/randomforge/commit/57323aa231937be2c3340ba2c6a50acd119755d1/checks) |
| Running  | Ubuntu 24.04.3 LTS           |                                                                                                                                                                                             |
| Language | C                            |                                                                                                                                                                                             |
| Timezone | UTC                          |                                                                                                                                                                                             |

| Package     | Version    |
|:------------|:-----------|
| testthat    | 3.3.0      |
| covr        | 3.6.5      |
| covrpage    | 0.2        |
| randomforge | 0.1.0.9046 |

Tests are run using the [`testthat`](https://github.com/r-lib/testthat)
package. This summary is created by the
[`covrpage`](https://github.com/yonicd/covrpage) package.
