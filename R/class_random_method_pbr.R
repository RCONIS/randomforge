
#'
#' Create a Permuted Block Randomization Method Instance
#'
#' @description
#' Constructs and returns a new `RandomMethodPBR` reference class object, 
#' configured for permuted block randomization with specified block 
#' sizes and design options.
#'
#' @param ... Additional arguments passed to the `RandomMethodPBR` initializer.
#' @param blockSizes List of block size configurations, each mapping treatment arm IDs to sizes.
#' @param fixedBlockDesignEnabled Logical indicating if a fixed block design is used (default: TRUE).
#' @param fixedBlockIndex Integer specifying the index of the fixed block size to use (default: 1).
#' @param blockSizeRandomizer `RandomBlockSizeRandomizer` object for selecting block sizes randomly.
#'
#' @return A `RandomMethodPBR` reference class object.
#' 
#' @seealso \code{\link[=RandomMethodPBR]{RandomMethodPBR}}
#'
#' @export
#' 
getRandomMethodPBR <- function(...,
        blockSizes = list(),
        fixedBlockDesignEnabled = TRUE,
        fixedBlockIndex = 1L,
        blockSizeRandomizer = getRandomBlockSizeRandomizer()) {
    return(RandomMethodPBR(
        blockSizes = blockSizes,
        fixedBlockDesignEnabled = fixedBlockDesignEnabled,
        fixedBlockIndex = fixedBlockIndex,
        blockSizeRandomizer = blockSizeRandomizer
    ))
}

#'
#' RandomMethodPBR Reference Class
#'
#' @description
#' Implements the Permuted Block Randomization (PBR) method, supporting 
#' both fixed and randomized block designs for treatment allocation.
#'
#' @field name Character string specifying the method name.
#' @field uniqueId Character string uniquely identifying the method instance.
#' @field blockSizeRandomizer `RandomBlockSizeRandomizer` object for selecting block sizes randomly.
#' @field blockSizes List of block size configurations, each mapping treatment arm IDs to sizes.
#' @field fixedBlockDesignEnabled Logical indicating if a fixed block design is used.
#' @field fixedBlockIndex Integer specifying the index of the fixed block size to use.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(...)}{Initializes a new `RandomMethodPBR` instance, 
#'     validates block size settings, and assigns a unique ID.}
#'   \item{show()}{Prints a string representation of the method.}
#'   \item{toString()}{Returns a string representation of the method and its configuration.}
#'   \item{randomize(factorLevels, randomSystemState, randomAllocationValue)}{Performs 
#'     randomization using PBR, updates system state, and returns a `RandomResult`.}
#'   \item{getNextRandomBlockSize()}{Retrieves the next block size configuration, either fixed or randomized.}
#' }
#'
#' @keywords internal
#' 
#' @seealso \code{\link[=getRandomMethodPBR]{getRandomMethodPBR()}}
#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomMethodPBR <- setRefClass("RandomMethodPBR",
    fields = list(
        name = "character",
        uniqueId = "character",
        blockSizeRandomizer = "RandomBlockSizeRandomizer",
        blockSizes = "list",
        fixedBlockDesignEnabled = "logical",
        fixedBlockIndex = "integer"
    ),
    methods = list(
        initialize = function(...,
                name = "PBR",
                blockSizes = list(),
                fixedBlockDesignEnabled = TRUE,
                fixedBlockIndex = 1L,
                blockSizeRandomizer = getRandomBlockSizeRandomizer()) {
            callSuper(name = name,
                blockSizes = blockSizes, fixedBlockDesignEnabled = fixedBlockDesignEnabled,
                fixedBlockIndex = fixedBlockIndex, blockSizeRandomizer = blockSizeRandomizer, ...
            )
            if (fixedBlockDesignEnabled && length(blockSizes) > 1) {
                warning("Only 1 of ", length(blockSizes), " defined block sizes will be used")
            }
            if (fixedBlockDesignEnabled && (fixedBlockIndex < 1 || fixedBlockIndex > length(blockSizes))) {
                stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
                    "'fixedBlockIndex' (", fixedBlockIndex, ") out of bounds [1; ", length(blockSizes), "]")
            }
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            sb <- StringBuilder()
            sb$append(name)
            
            for (blockSize in blockSizes) {
                sb2 <- StringBuilder()
                for (treatmentId in names(blockSize)) {
                    if (!sb2$isEmpty()) {
                        sb2$append(", ")
                    }
                    sb2$append(treatmentId, ":", blockSize[[treatmentId]])                
                }
                sb$append(", block-size[")
                sb$append(sb2$toString())
                sb$append("]")
            }
            
            sb$append(", fixedBlockDesignEnabled:", fixedBlockDesignEnabled)
            sb$append(", fixedBlockIndex:", fixedBlockIndex)
            return(sb$toString())
        },
        randomize = function(factorLevels, randomSystemState, randomAllocationValue) {
            message("Randomize using PBR...")
            if (is.null(blockSizes) || length(blockSizes) == 0) {
                stop(
                    "No block sizes defined: ",
                    "the random configuration has never been set before"
                )
            }
            result <- RandomResult()
            message("Get block...")
            randomBlock <- randomSystemState$getBlock(factorLevels, randomBlockSizeGenerator = .self)
            if (is.null(randomBlock)) {
                stop("Failed to get block")
            }

            rangeSet <- RandomMethodRangeSetPBR(randomBlock)
            rangeSet$initRanges(randomBlock$getProbabilities())
            treatmentArmId <- rangeSet$indexOf(randomAllocationValue)
            randomBlock$incrementSize(treatmentArmId)
            result$treatmentArmId <- treatmentArmId
            randomSystemState$incrementFillingLevel(treatmentArmId)
            randomSystemState$setFillingLevelsBlock(randomBlock)
            result$randomMethodRangeSet <- rangeSet
            result$randomSystemState <- randomSystemState
            return(result)
        },
        getNextRandomBlockSize = function() {
            if (is.null(blockSizes) || length(blockSizes) == 0) {
                stop("No block sizes are defined")
            }

            if (length(blockSizes) == 1) {
                return(blockSizes[[1]])
            }

            if (fixedBlockDesignEnabled) {
                randomIndex <- fixedBlockIndex
            } else {
                if (is.null(blockSizeRandomizer)) {
                    stop("'blockSizeRandomizer' is not initialized")
                }
                randomIndex <- blockSizeRandomizer$nextInt(length(blockSizes))
                message("Get next random block size (index = ", randomIndex, ")")
            }

            blockSize <- blockSizes[[randomIndex]]

            # TODO logging
            # Map<String, Object> rndLoggerValues = new HashMap<String, Object>()
            # rndLoggerValues.put("blockSize", "new random block size: " + blockSize + " (random index: " + randomIndex + ")")
            # logger.info("Random configuration set: " + rndLoggerValues)

            return(blockSize)
        }
    )
)
