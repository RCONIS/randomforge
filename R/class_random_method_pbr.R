
#' @export
getRandomMethodPBR <- function(...,
        blockSizes = list(),
        fixedBlockDesignEnabled = TRUE,
        fixedBlockIndex = 1L,
        blockSizeRandomizer = RandomBlockSizeRandomizer()) {
    return(RandomMethodPBR(
        blockSizes = blockSizes,
        fixedBlockDesignEnabled = fixedBlockDesignEnabled,
        fixedBlockIndex = fixedBlockIndex,
        blockSizeRandomizer = blockSizeRandomizer
    ))
}

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
                blockSizeRandomizer = RandomBlockSizeRandomizer()) {
            callSuper(name = name,
                blockSizes = blockSizes, fixedBlockDesignEnabled = fixedBlockDesignEnabled,
                fixedBlockIndex = fixedBlockIndex, blockSizeRandomizer = blockSizeRandomizer, ...
            )
            if (fixedBlockDesignEnabled && length(blockSizes) > 1) {
                warning("Only 1 of ", length(blockSizes), " defined block sizes will be used")
            }
            if (fixedBlockDesignEnabled && (fixedBlockIndex < 1 || fixedBlockIndex > length(blockSizes))) {
                stop("Illegal argument: 'fixedBlockIndex' (", fixedBlockIndex, ") out of bounds [1; ", length(blockSizes), "]")
            }
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
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

            #            Map<String, Object> rndLoggerValues = new HashMap<String, Object>()
            #            rndLoggerValues.put("blockSize", "new random block size: " + blockSize + " (random index: " + randomIndex + ")")
            #            logger.info("Random configuration set: " + rndLoggerValues)

            return(blockSize)
        }
    )
)
