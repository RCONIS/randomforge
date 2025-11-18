
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