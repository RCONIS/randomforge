
test_that("Test block size assertions", {

    expect_error(assertIsValidBlockSize(list("A" = 3, "B" = 3)), NA)
    expect_error(assertIsValidBlockSize(list("A" = 3, "B" = 0)))
    expect_error(assertIsValidBlockSize(list("A" = 3, 3)))
    expect_error(assertIsValidBlockSize(list("A" = 3)))
    
    blockSizes <- list()
    blockSizes[[1]] <- list("A" = 2, "B" = 2)
    blockSizes[[2]] <- list("A" = 3, "B" = 0)
    expect_error(assertAreValidBlockSizes(blockSizes))
})
        

test_that("Test block size generation and validation", {

    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = NA_real_), NA)
    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = c(0.3, 0.7)))
    expect_error(getBlockSize(c("A", "B"), 4, allocationFraction = c(0.25, 0.75)), NA)
    expect_error(getBlockSize(c("A", "B", "C"), 4, allocationFraction = c(0.25, 0.5, 0.25)), NA)
    expect_error(getBlockSize(c("A", "B", "C"), 4))
    expect_error(getBlockSize(c("A", "B", "C"), 6), NA)
})
        