
#'
#' RandomBlockArm Reference Class
#'
#' @description
#' Represents a treatment arm within a randomization block, tracking its 
#' allocation status and limits. Provides methods for initialization, 
#' cloning, display, size management, and completion checks.
#'
#' @field treatmentArmId Character ID of the treatment arm.
#' @field maximumSize Integer specifying the maximum allowed allocations for this arm.
#' @field currentSize Integer tracking the current number of allocations.
#' @field enabled Logical indicating if the arm is active for allocation.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(treatmentArmId, maximumSize, ..., 
#'     currentSize = 0L, enabled = TRUE)}{Initializes a new `RandomBlockArm` instance.}
#'   \item{clone()}{Creates a deep copy of the block arm.}
#'   \item{show()}{Displays a summary of the block arm.}
#'   \item{toString()}{Returns a string representation of the block arm.}
#'   \item{incrementSize()}{Increments the current allocation size, with validation.}
#'   \item{isCompleted()}{Checks if the arm has reached its maximum allocation or is disabled.}
#'   \item{getCurrentSize()}{Returns the current allocation size.}
#'   \item{getMaximumSize()}{Returns the maximum allocation size.}
#' }
#'
#' @keywords internal
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


