

#'
#' RandomMethodRangeSetPBR Reference Class
#'
#' @description
#' Extends `RandomMethodRangeSet` to support probability block randomization, initializing ranges based on a `RandomBlock` object.
#'
#' @field Inherits all fields from `RandomMethodRangeSet`.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(block, ...)}{Initializes a new `RandomMethodRangeSetPBR` instance using a `RandomBlock`. Validates the block and sets up ranges according to its probabilities.}
#' }
#'
#' @keywords internal
#' 
#' @include class_random_method_range_set.R
#' 
RandomMethodRangeSetPBR <- setRefClass("RandomMethodRangeSetPBR",
    contains = "RandomMethodRangeSet",
    methods = list(
        initialize = function(block, ...) {
            callSuper(...)
            if (!inherits(block, "RandomBlock")) {
                stop("'block' must be an instance of class 'RandomBlock' (is ", class(block), ")")
            }
            
            if (block$isCompleted()) {
                stop("The specified block '", block$toString(), "' is completed")
            }
            
            initRanges(block$getProbabilities())
        }
    )
)