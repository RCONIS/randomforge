
#'
#' 
#' 
RandomBlockArm <- setRefClass("RandomBlockArm",
    fields = list(
        treatmentArmId = "character",
        maximumSize = "integer",
        currentSize = "integer",
        enabled = "logical"
    ),
    methods = list(
        initialize = function(
                treatmentArmId, 
                maximumSize, 
                ..., 
                currentSize = 0L, 
                enabled = TRUE) {
            callSuper(
                treatmentArmId = treatmentArmId,
                maximumSize = as.integer(maximumSize),
                currentSize = currentSize,
                enabled = enabled,
                ...)
        },
        clone = function() {
            randomBlockArm <- RandomBlockArm(
                treatmentArmId = .self$treatmentArmId,
                maximumSize = .self$maximumSize,
                currentSize = .self$currentSize,
                enabled = .self$enabled
            )
            return(randomBlockArm)
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            sb <- StringBuilder();
            sb$append(treatmentArmId)
            sb$append(":")
            sb$append(currentSize)
            sb$append("/")
            sb$append(maximumSize)
            return(sb$toString())
        },
        incrementSize = function() {
            if (currentSize > maximumSize) {
                stop("The current size ", currentSize, 
                    " is larger than the allowed maximum size ", maximumSize)
            }
            if (currentSize == maximumSize) {
                stop("The current size ", currentSize, 
                    " is equal to the allowed maximum size ", maximumSize)
            }
            currentSize <<- currentSize + 1L
        },
        isCompleted = function() {
            if (!enabled) {
                return(TRUE)
            }
            
            if (currentSize > maximumSize) {
                stop("The current size ", currentSize, 
                    " is larger than the allowed maximum size ", maximumSize)
            }
            
            return(currentSize == maximumSize)
        },
        getCurrentSize = function() {
            return(currentSize)
        },
        getMaximumSize = function() {
            return(maximumSize)
        }
    )
)


