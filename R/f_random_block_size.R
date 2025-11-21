
.getAvailableBlockAllocationFractions <- function(numberOfTreatments, blockSize) {
    compositionsRecursive <- function(total, k) {
        if (k == 1) {
            return(list(c(total)))
        }
        
        out <- list()
        for (i in 1:(total - k + 1)) {  # ensure positivity
            sub <- compositionsRecursive(total - i, k - 1)
            for (s in sub) {
                out[[length(out) + 1]] <- c(i, s)
            }
        }
        out
    }
    
    # integer allocations (counts per arm)
    integerAllocations <- compositionsRecursive(blockSize, numberOfTreatments)
    
    # convert to allocation fractions
    availableAllocationFractions <- lapply(
        integerAllocations,
        function(x) x / blockSize
    )
    
    return(availableAllocationFractions)
}

.isFractionAvailable <- function(allocationFraction, availableAllocationFractions) {
    for (availableAllocationFraction in availableAllocationFractions) {
        if (all(abs(availableAllocationFraction - allocationFraction) < 1e-07)) {
            return(TRUE)
        }
    }
    return(FALSE)
}

#' @export 
getBlockSizes <- function(treatmentArmIds, blockSizes, allocationFraction = NA_real_) {
    .assertIsIntegerVector(blockSizes, "blockSizes", validateType = FALSE)
    if (length(blockSizes) == 0) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "at leat one block size must be specified")
    }
    result <- list()
    for (blockSize in blockSizes) {
        result[[length(result) + 1]] <- getBlockSize(
            treatmentArmIds = treatmentArmIds, 
            blockSize = blockSize, 
            allocationFraction = allocationFraction)
    }
    return(result)
}

#' @export 
getBlockSize <- function(treatmentArmIds, blockSize, allocationFraction = NA_real_) {
    .assertIsCharacter(treatmentArmIds, "treatmentArmIds")
    .assertIsSingleInteger(blockSize, "blockSize", validateType = FALSE)
    .assertIsNumericVector(allocationFraction, "allocationFraction", naAllowed = TRUE)
    
    numberOfTreatments <- length(treatmentArmIds)
    if (numberOfTreatments < 2) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            "'treatmentArmIds' must define at least two treatment arms")
    }
    
    if (any(is.na(allocationFraction))) {
        allocationFraction <- rep(1, numberOfTreatments) / numberOfTreatments
    }
    
    if (blockSize == numberOfTreatments) {
        if (allocationRatio != 1) {
            warning("'allocationRatio' (", allocationRatio, ") will be ignored", call. = FALSE)
        }
        
        block <- list()
        for (treatmentArmId in treatmentArmIds) {
            block[[treatmentArmId]] <- 1L
        }
        return(block)
    }
    
    if (length(allocationFraction) != numberOfTreatments) {
        stop(C_EXCEPTION_TYPE_CONFLICTING_ARGUMENTS, 
            "for each treatment arm an allocation fraction must be specified")
    }
    
    availableAllocationFractions <- .getAvailableBlockAllocationFractions(numberOfTreatments, blockSize)
    if (!.isFractionAvailable(allocationFraction, availableAllocationFractions)) {
        print(availableAllocationFractions)
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "'allocationFraction' (", 
            .arrayToString(allocationFraction), ") is not allowed")
    }
    
    block <- list()
    for (i in seq_along(treatmentArmIds)) {
        treatmentArmId <- treatmentArmIds[i]
        block[[treatmentArmId]] <- allocationFraction[i] * blockSize
    }
    return(block)
}

assertAreValidBlockSizes <- function(blockSizes) {
    if (is.null(blockSizes) || length(blockSizes) == 0 || !is.list(blockSizes)) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            "'blockSizes' must be a non-empty list", call. = FALSE)
    }
    for (i in seq_along(blockSizes)) {
        assertIsValidBlockSize(blockSizes[[i]], paramName = paste0("blockSizes[[", i, "]]"))
    }
}

assertIsValidBlockSize <- function(blockSize, paramName = "blockSize") {
    if (is.null(blockSize) || length(blockSize) == 0 || !is.list(blockSize)) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            sQuote(paramName), " must be a list", call. = FALSE)
    }
    if (length(blockSize) < 2) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            sQuote(paramName), " must contain at least two treatment arms", call. = FALSE)
    }
    if (is.null(names(blockSize)) || any(names(blockSize) == "")) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            "all ", sQuote(paramName), " elements must be named", call. = FALSE)
    }
    blockSizes <- unlist(blockSize, use.names = FALSE)
    if (any(is.na(blockSizes)) || any(blockSizes <= 0) || any(blockSizes != as.integer(blockSizes))) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            "all ", sQuote(paramName), " elements must be positive integers", call. = FALSE)
    }
}
