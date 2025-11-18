

#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' @include class_random_system_state.R
#' @include class_random_method_range_set.R
#' 
RandomResult <- setRefClass("RandomResult",
    fields = list(
        uniqueId = "character",
        randomizationDate = "POSIXct",
        treatmentArmId = "character",
        randomSystemState = "RandomSystemState",
        randomMethodRangeSet = "RandomMethodRangeSet"
    ),
    methods = list(
        initialize = function(..., randomizationDate = Sys.time()) {
            callSuper(randomizationDate = randomizationDate, ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(.self$toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            sb <- StringBuilder()
            sb$append(prefix, "random-result[")
            sb$append("treatment:", treatmentArmId, ", ")
            sb$append(randomSystemState$toString(), ", ")
            sb$append(randomMethodRangeSet$toString())
            sb$append("]")
            return(sb$toString())
        }
    )
)
