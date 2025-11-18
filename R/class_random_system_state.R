
#'
#' @title Random System State
#' 
#' @field fillingLevelsOverall
#' @field fillingLevelsBlock
#' @field fillingLevelsBlockMaximum
#' @field fillingLevelsStratum
#' @field fillingLevelsFactor
#' 
#' @details 
#' 
#' \code{fillingLevelsBlock}: 
#' Contains the filling levels of each treatment arm respectively inside each block,
#' where a block exists for each stratum. <br/><br/>
#' 
#' Example: B = 6
#' <ul>
#'   <li>RandomBlock 1 (gender: male)
#'     <ul>
#'       <li>Treatment 1 = 2</li>
#'       <li>Treatment 2 = 2</li>
#'       <li>Treatment 3 = 2</li>
#'     </ul>
#'   </li>
#'   <li>RandomBlock 2 (gender: female)
#'     <ul>
#'       <li>Treatment 1 = 2</li>
#'       <li>Treatment 2 = 1</li>
#'       <li>Treatment 3 = 2</li>
#'     </ul>
#'   </li>
#' </ul>
#' <br/><br/>
#' 
#' Data format: <code>Map(key = 'block id' = 'strata id', value = 'treatment filling level')</code>.
#' 
#' \code{fillingLevelsStratum}: 
#' 
#' Contains the filling levels of each treatment arm respectively inside each stratum. <br/><br/>
#' 
#' Example:
#' <ul>
#'   <li>Gender: male
#'     <ul>
#'       <li>Treatment 1 = 5</li>
#'       <li>Treatment 2 = 5</li>
#'       <li>Treatment 3 = 3</li>
#'     </ul>
#'   </li>
#'   <li>Gender: female
#'     <ul>
#'       <li>Treatment 1 = 4</li>
#'       <li>Treatment 2 = 4</li>
#'       <li>Treatment 3 = 5</li>
#'     </ul>
#'   </li>
#' </ul>
#' <br/><br/>
#' 
#' Data format: <code>Map(key = 'strata id', value = 'treatment filling level')</code>.
#' 
#' \code{fillingLevelsFactor}:
#' 
#' Contains the filling levels of each treatment arm respectively inside each factor level. <br/><br/>
#' 
#' Example:
#' <ul>
#'   <li>Gender: male
#'     <ul>
#'       <li>Treatment 1 = 5</li>
#'       <li>Treatment 2 = 5</li>
#'       <li>Treatment 3 = 3</li>
#'     </ul>
#'   </li>
#'   <li>Gender: female
#'     <ul>
#'       <li>Treatment 1 = 4</li>
#'       <li>Treatment 2 = 4</li>
#'       <li>Treatment 3 = 5</li>
#'     </ul>
#'   </li>
#' </ul>
#' <br/><br/>
#' 
#' Data format: <code>Map(key = 'factor level id', value = 'treatment filling level')</code>.
#' 
#' @include class_general_unique_id_builder.R
#' 
NULL

#'
#' Convert RandomSystemState to Data Frame
#'
#' @description
#' Converts a `RandomSystemState` object into a data frame containing overall and block-wise treatment arm filling levels.
#'
#' @param x A `RandomSystemState` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return A data frame with columns for overall and block-wise treatment arm filling levels.
#'
#' @keywords internal
#' 
#' @export 
#' 
as.data.frame.RandomSystemState <- function(x, ...) {
    df <- .treatmentListToDataFrame(x$fillingLevelsOverall, "overall-levels-")
    df <- cbind(df, .treatmentListToDataFrame(as.list(as.data.frame(x$blocks[[1]])), "block-wise-levels-"))
    return(df)
}

#'
#' RandomSystemState Reference Class
#'
#' @description
#' Represents the state of a randomization system, tracking filling 
#' levels for treatment arms across overall, block, stratum, and factor levels.
#'
#' @field uniqueId Character string uniquely identifying the system state.
#' @field fillingLevelsOverall List of overall filling levels for each treatment arm.
#' @field blocks List of block objects for each stratum.
#' @field fillingLevelsBlock List of filling levels for each treatment arm within each block.
#' @field fillingLevelsBlockMaximum List of maximum filling levels for each treatment arm within each block.
#' @field fillingLevelsStratum List of filling levels for each treatment arm within each stratum.
#' @field fillingLevelsFactor List of filling levels for each treatment arm within each factor level.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(...)}{Initializes a new `RandomSystemState` instance.}
#'   \item{show(prefix = "")}{Prints a summary of the system state.}
#'   \item{toString(prefix = "")}{Returns a string representation of the system state.}
#'   \item{init(treatmentArmIds, ..., factorIds = NULL, strataIds = NULL)}{Initializes filling levels for treatment arms, factors, and strata.}
#'   \item{clone()}{Creates a deep copy of the system state.}
#'   \item{getBlock(factorLevels, randomBlockSizeGenerator)}{Retrieves or creates a block for the given factor levels.}
#'   \item{incrementFillingLevel(treatmentArmId)}{Increments the overall filling level for a treatment arm.}
#'   \item{setFillingLevelsBlock(randomBlock)}{Sets the filling levels for a block.}
#' }
#' 
#' @include f_constants.R
#'
#' @keywords internal
#' 
#' @export
#' 
RandomSystemState <- setRefClass("RandomSystemState",
    fields = list(
        uniqueId = "character",
        fillingLevelsOverall = "list",
        blocks = "list",
        fillingLevelsBlock = "list",
        fillingLevelsBlockMaximum = "list",
        fillingLevelsStratum = "list",
        fillingLevelsFactor = "list"
    ),
    methods = list(
        initialize = function(..., 
                fillingLevelsOverall = list(),
                blocks = list(),
                fillingLevelsBlock = list(),
                fillingLevelsBlockMaximum = list(),
                fillingLevelsStratum = list(),
                fillingLevelsFactor = list()
                ) {
            callSuper(
                fillingLevelsOverall = fillingLevelsOverall, 
                blocks = blocks, 
                fillingLevelsBlock = fillingLevelsBlock, 
                fillingLevelsBlockMaximum = fillingLevelsBlockMaximum, 
                fillingLevelsStratum = fillingLevelsStratum, 
                fillingLevelsFactor = fillingLevelsFactor, 
                ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            sb <- StringBuilder()
            if (!is.null(fillingLevelsOverall) && length(fillingLevelsOverall) > 0) {
                sb$append(prefix, "overall-levels[")
                sb2 <- StringBuilder()
                for (treatmentArmId in names(fillingLevelsOverall)) {
                    if (!sb2$isEmpty()) {
                        sb2$append(", ")
                    }
                    sb2$append(treatmentArmId, ":", fillingLevelsOverall[[treatmentArmId]])
                }
                sb$append(sb2$toString())
                sb$append("]")
            }
            if (!is.null(blocks) && length(blocks) > 0) {
                sb2 <- StringBuilder()
                for (block in blocks) {
                    if (!sb2$isEmpty()) {
                        sb2$append(", ")
                    }
                    sb2$append(block$toString())
                }
                if (!sb$isEmpty()) {
                    sb$append(", ")
                }
                sb$append(sb2$toString())
            }
#            if (!is.null(fillingLevelsBlock) && length(fillingLevelsBlock) > 0) {
#                for (stratumId in names(fillingLevelsBlock)) {
#                    blockList = fillingLevelsBlock[[stratumId]]
#                    if (is.null(blockList) || length(blockList) == 0) {
#                        stop("Runtime issue: block list of stratum ", sQuote(stratumId), " is empty")
#                    }
#                    
#                    if (!sb$isEmpty()) {
#                        sb$append(", ")
#                    }
#                    
#                    sb$append("B(")
#                    if (stratumId != NO_FACTOR_ID) {
#                        sb$append(stratumId, ": ")
#                    }
#                    sb2 <- StringBuilder()
#                    for (treatmentArmId in names(blockList)) {
#                        if (!sb2$isEmpty()) {
#                            sb2$append(", ")
#                        }
#                        sb2$append(treatmentArmId, "=", blockList[[treatmentArmId]])
#                    }
#                    sb$append(sb2$toString())                    
#                    sb$append(")")
#                }
#            }
            if (sb$isEmpty()) {
                sb$append(prefix, uniqueId)
            }
            return(sb$toString())
        },
        init = function(treatmentArmIds, ..., factorIds = NULL, strataIds = NULL) {
            if (!is.null(treatmentArmIds) && length(treatmentArmIds) > 0) {
                for (treatmentArmId in treatmentArmIds) {
                    fillingLevelsOverall[[treatmentArmId]] <<- 0L
                }
            }
            if (!is.null(factorIds) && length(factorIds) > 0) {
                for (factorId in factorIds) {
                    fillingLevelsFactor[[factorId]] <<- createFillingLevelsMap(treatmentArmIds)
                }
            }
            if (!is.null(strataIds) && length(strataIds) > 0) {
                for (strataId in strataIds) {
                    fillingLevelsStratum[[strataId]] <<- createFillingLevelsMap(treatmentArmIds)
                }
            }
        },
        clone = function() {
            randomSystemState <- RandomSystemState()
            randomSystemState$fillingLevelsOverall <- .self$fillingLevelsOverall
            randomSystemState$blocks <- list()
            for (stratumId in names(.self$blocks)) {
                block <- blocks[[stratumId]]
                randomSystemState$blocks[[stratumId]] <- block$clone()
            }
            randomSystemState$fillingLevelsBlock <- .self$fillingLevelsBlock
            randomSystemState$fillingLevelsBlockMaximum <- .self$fillingLevelsBlockMaximum
            randomSystemState$fillingLevelsStratum <- .self$fillingLevelsStratum
            randomSystemState$fillingLevelsFactor <- .self$fillingLevelsFactor
            return(randomSystemState)
        },
        getBlock = function(factorLevels, randomBlockSizeGenerator) {
            stratumId <- createStratumId(factorLevels)
            block <- blocks[[stratumId]]
            if (is.null(block) || block$isCompleted()) {
                message("Create new block...")
                block <- RandomBlock(
                    maximumBlockSize = randomBlockSizeGenerator$getNextRandomBlockSize(), 
                    factorLevels = factorLevels)
                blocks[[stratumId]] <<- block
            } else {
                message("Use existing block...")
            }
            return(block)
        },
        incrementFillingLevel = function(treatmentArmId) {
            fillingLevel <- fillingLevelsOverall[[treatmentArmId]]
            if (is.null(fillingLevel)) {
                fillingLevel <- 0L
            }
            fillingLevel <- fillingLevel + 1L
            fillingLevelsOverall[[treatmentArmId]] <<- fillingLevel
            
            # TODO increment also factor and strata levels
        },
        setFillingLevelsBlock = function(randomBlock) {
            factorLevels <- randomBlock$factorLevels
            stratumId <- createStratumId(factorLevels)
            blockFillingLevels <- fillingLevelsBlock[[stratumId]]
            if (is.null(blockFillingLevels)) {
                blockFillingLevels <- list()
            }
            blockMaximumFillingLevels <- fillingLevelsBlockMaximum[[stratumId]]
            if (is.null(blockMaximumFillingLevels)) {
                blockMaximumFillingLevels <- list()
            }
            for (blockArmId in names(randomBlock$blockArms)) {
                blockFillingLevels[[blockArmId]] <- randomBlock$blockArms[[blockArmId]]$getCurrentSize()
                blockMaximumFillingLevels[[blockArmId]] <- randomBlock$blockArms[[blockArmId]]$getMaximumSize()
            }
            fillingLevelsBlock[[stratumId]] <<- blockFillingLevels
            fillingLevelsBlockMaximum[[stratumId]] <<- blockMaximumFillingLevels
        }
    )
)
