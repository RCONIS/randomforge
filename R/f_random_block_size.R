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

#'
#' Get Available Block Allocation Fractions
#'
#' @description
#' Computes all possible allocation fractions for a given number of treatment 
#' arms and block size. Each fraction represents a valid way to distribute 
#' subjects among treatment arms within a block, ensuring only positive 
#' integer allocations.
#'
#' @param numberOfTreatments Integer specifying the number of treatment arms.
#' @param blockSize Integer specifying the size of the block.
#'
#' @return A list of numeric vectors, each representing a possible 
#'         allocation fraction for the block.
#'
#' @keywords internal
#'
#' @noRd
#' 
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

#'
#' Check If Allocation Fraction Is Available
#'
#' @description
#' Determines whether a given allocation fraction matches any of the available 
#' allocation fractions for a block size and number of treatment arms. 
#' Uses a numerical tolerance to account for floating-point precision.
#'
#' @param allocationFraction Numeric vector specifying the allocation fraction to check.
#' @param availableAllocationFractions List of numeric vectors representing valid allocation fractions.
#'
#' @return Logical value indicating whether the allocation fraction 
#'         is available (\code{TRUE}) or not (\code{FALSE}).
#'
#' @keywords internal
#'
#' @noRd
#' 
.isFractionAvailable <- function(allocationFraction, availableAllocationFractions) {
    for (availableAllocationFraction in availableAllocationFractions) {
        if (all(abs(availableAllocationFraction - allocationFraction) < 1e-07)) {
            return(TRUE)
        }
    }
    return(FALSE)
}

#'
#' Get Block Sizes for Treatment Arms
#'
#' @description
#' Generates a list of block sizes per treatment arm for specified treatment arms and 
#' total block sizes. Each block size per treatment arm is computed according to the provided 
#' allocation fraction or defaults to equal allocation if not specified.
#'
#' @param treatmentArmIds Character vector of treatment arm identifiers.
#' @param blockSizes Integer vector specifying the total block sizes to use. 
#'        If more than one block size is provided, variable block sizes will be used.
#' @param allocationFraction Numeric vector specifying the allocation 
#'        fraction for each treatment arm. Defaults to equal allocation 
#'        if \code{NA}.
#'
#' @return A list of block allocations, each represented as a named 
#'        list of counts per treatment arm.
#'
#' @examples
#' # variable block sizes with 1:1 allocation ratio
#' getBlockSizes(c("A", "B"), c(4, 6))
#' 
#' # fixed block size with 2:1 allocation ratio
#' getBlockSizes(c("A", "B"), 9, c(2/3, 1/3))
#'
#' @export
#' 
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

#'
#' Get Block Size for Treatment Arms
#'
#' @description
#' Generates a list that represents one block with sizes per treatment arm for specified treatment arms and 
#' total block size. Each block size per treatment arm is computed according to the provided 
#' allocation fraction or defaults to equal allocation if not specified.
#' 
#' @param treatmentArmIds Character vector of treatment arm identifiers.
#' @param blockSize Integer specifying the block size.
#' @param allocationFraction Numeric vector specifying the allocation fraction for each treatment arm. Defaults to equal allocation if \code{NA}.
#'
#' @return A named list with counts of subjects per treatment arm for the block.
#'
#' @keywords internal
#'
#' @noRd
#' 
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

.assertAreValidBlockSizes <- function(blockSizes) {
    if (is.null(blockSizes) || length(blockSizes) == 0 || !is.list(blockSizes)) {
        stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
            "'blockSizes' must be a non-empty list", call. = FALSE)
    }
    for (i in seq_along(blockSizes)) {
        .assertIsValidBlockSize(blockSizes[[i]], paramName = paste0("blockSizes[[", i, "]]"))
    }
}

.assertIsValidBlockSize <- function(blockSize, paramName = "blockSize") {
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
