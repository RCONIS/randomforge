
#' 
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' @include class_random_configuration.R
#' @include class_random_result.R
#' 
RandomAllocationValue <- setRefClass("RandomAllocationValue",
    fields = list(
        uniqueId = "character",
        randomConfiguration = "RandomConfiguration",
        creationDate = "POSIXct",
        doubleValue = "numeric",
        randomResult = "RandomResult",
        hashValue = "integer"
    ),
    methods = list(
        initialize = function(..., creationDate = Sys.time()) {
            callSuper(creationDate = creationDate, ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            return(paste0(prefix, "rav:", doubleValue))
        },
        getDoubleValue = function() {
            return(doubleValue)
        }
    )
)

