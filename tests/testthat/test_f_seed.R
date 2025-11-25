# ------------------------------------------------------------------------------
#  randomforge — Innovating the Future of Randomization
#  Framework for transparent and extensible clinical trial randomization in R
#
#  Author: Friedrich Pahlke, RPACT GmbH
#  Copyright (c) 2025
#
#  This file is part of the randomforge R package.
#  The package is licensed under the GNU Lesser General Public License (LGPL-3.0).
#  Full license text: https://www.gnu.org/licenses/lgpl-3.0.txt
#
#  Source code and issue tracker:
#  https://github.com/RCONIS/randomforge
#
#  Documentation:
#  https://randomforge.org
#
#  For collaboration or contributions:
#  friedrich.pahlke@rpact.com
#  info@randomforge.org
# ------------------------------------------------------------------------------

test_that("For invalid input arguments 'createSeed' throws meaningful exceptions", {
    testthat::skip_if_not_installed("httr")
    testthat::skip_if_not_installed("glue")
    
    expect_error(createSeed(numberOfValues = 0), 
        "Argument out of bounds: 'numberOfValues' (0) is out of bounds [1; 1000]", fixed = TRUE)
    expect_error(createSeed(numberOfValues = 1, minValue = -1), 
        "Argument out of bounds: 'minValue' (-1) is out of bounds [1; 1e+08]", fixed = TRUE)
    expect_error(createSeed(numberOfValues = 1, maxValue = 0), 
        "Argument out of bounds: 'maxValue' (0) is out of bounds [1; 999999999]", fixed = TRUE)
    expect_error(createSeed(numberOfValues = 1, minValue = 101, maxValue = 100), 
        "Conflicting arguments: 'minValue' (101) must be smaller than argument 'maxValue'(100)", fixed = TRUE)
})

test_that("The results of 'createSeed' depend on the input arguments as expected", {
    testthat::skip_if_not_installed("httr")
    testthat::skip_if_not_installed("glue")
    
    expect_length(createSeed(), 1)
    expect_length(createSeed(numberOfValues = 9), 9)
    
    seed <- createSeed(numberOfValues = 100, minValue = 1000, maxValue = 5000)
    expect_true(all(seed >= 1000))
    expect_true(all(seed <= 5000))
})

test_that("'createSeed' returns valid seed although network connection is missing", {
    testthat::skip_if_not_installed("httr")
    testthat::skip_if_not_installed("glue")
        
    expect_warning(seed <- createSeed(
        minValue = 100000000, maxValue = 999999999,
        test_exception = "network error"
    ), "Failed to receive new seed from www.random.org: network error")
    
    expect_type(seed, "integer")
})