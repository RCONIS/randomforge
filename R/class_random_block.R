
#' @export 
as.data.frame.RandomBlock <- function(x, ...) {
    return(.treatmentListToDataFrame(x$blockArms))
}

#'
#' @title Random Block 
#' 
#' @field blockArms The map containing the block arms, 
#' format: [treatment arm id, RandomBlockArm]
#' @field factorLevels The strata and strata levels formatted as character list
#' where the key is the factor name or id and the value is the specific level (name or id).
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
            for (blockArm in blockArms) {
                if (!sb$isEmpty()) {
                    sb$append(", ")								
                }
                sb$append(blockArm$toString())
            }
            stratumId <- createStratumId(factorLevels)
            stratumInfo <- ""
            if (!identical(stratumId, NO_FACTOR_ID)) {
                stratumInfo <- paste0(stratumId, ": ")
            }
            sb$insert(1, paste0("block-wise-levels[", stratumInfo))
            sb$append("]")
            return(sb$toString())
        },
        assertBlockArmsAreValid = function() {
            if (is.null(blockArms)) {
                stop("The block arms are null")
            }
            if (length(blockArms) == 0) {
                stop("The block arms are empty")
            }
        },
        isCompleted = function() {
            assertBlockArmsAreValid()
            for (blockArm in blockArms) {
                if (!blockArm$isCompleted()) {
                    return(FALSE)
                }
            }
            return(TRUE)
        },
        getProbabilities = function() {
            assertBlockArmsAreValid()
            
            numberOfIncompleteBlockArms = 0
            for (blockArm in blockArms) {
                if (!blockArm$isCompleted()) {
                    numberOfIncompleteBlockArms <- numberOfIncompleteBlockArms + 1;
                }
            }
            fraction = 1 / numberOfIncompleteBlockArms;
            probabilities = list();
            for (treatmentArmId in names(blockArms)) {
                if (blockArms[[treatmentArmId]]$isCompleted()) {
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
            blockArm <- blockArms[[treatmentArmId]] 
            if (is.null(blockArm)) {
                stop("The treatment arm id ", 
                    sQuote(treatmentArmId), " does not exist")
            }
            return(blockArm)
        },
        keySet = function() {
            x <- names(blockArms)
            if (is.null(x)) {
                stop("Runtime issue: 'blockArms' must be a named list")
            }
            return(x)
        },
        get = function(key) {
            return(blockArms[[key]])
        },
        getTreatmentCount = function() {
            assertBlockArmsAreValid()
            return(length(blockArms))
        },
        #'
        #' @param treatmentArmIds the treatment arm id's.
        #' @param maximumBlockSize the maximum block length <code>B</code> for each treatment arm.
        #' @param factorLevels the optional factors and factor levels.
        #' 
        init = function(maximumBlockSize, currentBlockSize, factorLevels) {
            
            if (is.null(factorLevels)) {
                .self$factorLevels <<- list()
            } else {
                .self$factorLevels <<- factorLevels
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
                
                blockArms[[treatmentArmId]] <<- randomBlockArm
            }           
        }
    )
)

