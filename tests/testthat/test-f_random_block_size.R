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

test_that("Test block size assertions", {

    expect_error(.assertIsValidBlockSize(list("A" = 3, "B" = 3)), NA)
    expect_error(.assertIsValidBlockSize(list("A" = 3, "B" = 0)))
    expect_error(.assertIsValidBlockSize(list("A" = 3, 3)))
    expect_error(.assertIsValidBlockSize(list("A" = 3)))
    
    blockSizes <- list()
    blockSizes[[1]] <- list("A" = 2, "B" = 2)
    blockSizes[[2]] <- list("A" = 3, "B" = 0)
    expect_error(.assertAreValidBlockSizes(blockSizes))
})
        

test_that("Test block size generation and validation", {

    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = NA_real_), NA)
    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = c(0.3, 0.7)))
    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = c(0.25, 0.75)), NA)
    expect_error(getBlockSize(c("A", "B", "C"), 4, allocationFraction = c(0.25, 0.5, 0.25)), NA)
    expect_error(getBlockSize(c("A", "B", "C"), 4))
    expect_error(getBlockSize(c("A", "B", "C"), 6), NA)
})
        