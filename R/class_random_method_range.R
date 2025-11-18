#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomMethodRange <- setRefClass("RandomMethodRange",
    fields = list(
        uniqueId = "character",
        treatmentArmId = "character",
        lowerBound = "numeric",
        upperBound = "numeric"
    ),
    methods = list(
        initialize = function(
                ...,
                treatmentArmId, 
                lowerBound, 
                upperBound) {
            callSuper(
                treatmentArmId = treatmentArmId, 
                lowerBound = lowerBound, 
                upperBound = upperBound, 
                ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function(randomAllocationValue = NULL) {
            sb <- StringBuilder()
            if (is.null(randomAllocationValue)) {
                sb$append("[")
                sb$append(round(lowerBound, 2))
                sb$append(",")
                sb$append(round(upperBound, 2))
                sb$append("]")
                return(sb$toString())
            }

            sb$append("[")
            sb$append(round(lowerBound, 2))
            sb$append("<=")
            sb$append(randomAllocationValue)
            sb$append("<=")
            sb$append(round(upperBound, 2))
            sb$append("]")
            return(sb$toString())
        },
        contains = function(value) {
            if (lowerBound == 0) {
                return(value >= lowerBound && value <= upperBound)
            }
            
            return(value > lowerBound && value <= upperBound)
        }
    )
)


