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
#' Convert RandomBlock Arms to Data Frame
#'
#' @description
#' Converts the list of `RandomBlockArm` objects stored in a `RandomBlock` 
#' instance into a data frame by applying `.treatmentListToDataFrame` to the block arms.
#'
#' @param x A `RandomBlock` reference class object.
#' @param ... Additional arguments passed to the conversion function.
#'
#' @return A data frame containing all block arms from the block.
#' 
#' @seealso \code{\link[=RandomBlock]{RandomBlock}}
#'
#' @export
#' 
as.data.frame.RandomBlock <- function(x, ...) {
    return(.treatmentListToDataFrame(x$blockArms))
}

#'
#' RandomBlock Reference Class
#'
#' @description
#' Represents a block of treatment arms for randomization, with associated factor levels (strata). Provides methods for initialization, cloning, display, validation, probability calculation, and block arm management.
#'
#' @field blockArms List mapping treatment arm IDs to `RandomBlockArm` objects.
#' @field factorLevels List of strata and their levels, where keys are factor names or IDs and values are specific levels (name or ID).
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., maximumBlockSize, currentBlockSize, blockArms, factorLevels)}{Initializes a new `RandomBlock` instance, optionally setting up block arms and factor levels.}
#'   \item{clone()}{Creates a deep copy of the block and its arms.}
#'   \item{show()}{Displays a summary of the block.}
#'   \item{toString()}{Returns a string representation of the block and its arms.}
#'   \item{assertBlockArmsAreValid()}{Validates that block arms are present and non-empty.}
#'   \item{isCompleted()}{Checks if all block arms are completed.}
#'   \item{getProbabilities()}{Returns a list of allocation probabilities for each treatment arm.}
#'   \item{incrementSize(treatmentArmId)}{Increments the size of the specified block arm.}
#'   \item{getBlockArm(treatmentArmId)}{Retrieves the block arm for a given treatment arm ID.}
#'   \item{keySet()}{Returns the set of treatment arm IDs.}
#'   \item{get(key)}{Retrieves the block arm by key.}
#'   \item{getTreatmentCount()}{Returns the number of treatment arms.}
#'   \item{init(maximumBlockSize, currentBlockSize, factorLevels)}{Initializes block arms and factor levels.}
#' }
#' 
#' @seealso \code{\link[=as.data.frame.RandomBlock]{as.data.frame()}}
#'
#' @keywords internal
#' 
RandomBlock <- setRefClass("RandomBlock",
    fields = list(
        blockArms = "list",
        factorLevels = "list"
    ),
    methods = list(
        initialize = function(..., 
                maximumBlockSize = NA_integer_, 
                currentBlockSize = NULL, 
                blockArms = list(),
                factorLevels = list()) {
            callSuper(blockArms = blockArms, factorLevels = factorLevels, ...)
            if (is.list(maximumBlockSize)) {
                init(maximumBlockSize, currentBlockSize, factorLevels)
            }
        },
        clone = function() {
            randomBlock <- RandomBlock(factorLevels = .self$factorLevels)
            for (treatmentArmId in names(.self$blockArms)) {
                blockArm <- blockArms[[treatmentArmId]]
                randomBlock$blockArms[[treatmentArmId]] <- blockArm$clone()
            }
            return(randomBlock)
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            sb <- StringBuilder();
            for (blockArm in .self$blockArms) {
                if (!sb$isEmpty()) {
                    sb$append(", ")								
                }
                sb$append(blockArm$toString())
            }
            stratumId <- createStratumId(.self$factorLevels)
            stratumInfo <- ""
            if (!identical(stratumId, NO_FACTOR_ID)) {
                stratumInfo <- paste0(stratumId, ": ")
            }
            sb$insert(1, paste0("block-wise-levels[", stratumInfo))
            sb$append("]")
            return(sb$toString())
        },
        assertBlockArmsAreValid = function() {
            if (is.null(.self$blockArms)) {
                stop("The block arms are null")
            }
            if (length(.self$blockArms) == 0) {
                stop("The block arms are empty")
            }
        },
        isCompleted = function() {
            assertBlockArmsAreValid()
            for (blockArm in .self$blockArms) {
                if (!blockArm$isCompleted()) {
                    return(FALSE)
                }
            }
            return(TRUE)
        },
        getProbabilities = function() {
            assertBlockArmsAreValid()
            
            numberOfIncompleteBlockArms = 0
            for (blockArm in .self$blockArms) {
                if (!blockArm$isCompleted()) {
                    numberOfIncompleteBlockArms <- numberOfIncompleteBlockArms + 1;
                }
            }
            fraction = 1 / numberOfIncompleteBlockArms;
            probabilities = list();
            for (treatmentArmId in names(.self$blockArms)) {
                if (.self$blockArms[[treatmentArmId]]$isCompleted()) {
                    probabilities[[treatmentArmId]] <- 0;
                } else {
                    probabilities[[treatmentArmId]] <- fraction
                }
            }
            
            return(probabilities)
        },
        incrementSize = function(treatmentArmId) {
            randomBlockArm <- getBlockArm(treatmentArmId)
            randomBlockArm$incrementSize()
        },
        getBlockArm = function(treatmentArmId) {
            blockArm <- .self$blockArms[[treatmentArmId]] 
            if (is.null(blockArm)) {
                stop("The treatment arm id ", 
                    sQuote(treatmentArmId), " does not exist")
            }
            return(blockArm)
        },
        keySet = function() {
            x <- names(.self$blockArms)
            if (is.null(x)) {
                stop("Runtime issue: 'blockArms' must be a named list")
            }
            return(x)
        },
        get = function(key) {
            return(.self$blockArms[[key]])
        },
        getTreatmentCount = function() {
            assertBlockArmsAreValid()
            return(length(.self$blockArms))
        },
        #'
        #' @param treatmentArmIds the treatment arm id's.
        #' @param maximumBlockSize the maximum block length <code>B</code> for each treatment arm.
        #' @param factorLevels the optional factors and factor levels.
        #' 
        init = function(maximumBlockSize, currentBlockSize, factorLevels) {
            
            if (is.null(factorLevels)) {
                .self$factorLevels <- list()
            } else {
                .self$factorLevels <- factorLevels
            }
            
            for (treatmentArmId in names(maximumBlockSize)) {
                maximumSize <- maximumBlockSize[[treatmentArmId]]
                if (is.null(maximumSize)) {
                    stop("No block size specified for treatment arm ", 
                        sQuote(treatmentArmId))
                }
                
                randomBlockArm <- RandomBlockArm(
                    treatmentArmId = treatmentArmId, 
                    maximumSize = maximumSize)
                if (!is.null(currentBlockSize)) {
                    currentSize <- currentBlockSize[[treatmentArmId]]
                    if (!is.null(currentSize)) {
                        if (currentSize > maximumSize) {
                            stop("The current block size ", currentSize, " specified ",
                                "for treatment arm ", sQuote(treatmentArmId), " ",
                                "is greater than the maximum size ", maximumSize)
                        }
                        randomBlockArm$setCurrentSize(currentSize)
                    }
                }
                
                .self$blockArms[[treatmentArmId]] <- randomBlockArm
            }           
        }
    )
)

