
#' @export 
getRandomProject <- function(name) {
    return(RandomProject(name = name))
}

#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomProject <- setRefClass("RandomProject",
    fields = list(
        uniqueId = "character",
        name = "character",
        creationDate = "POSIXct"
    ),
    methods = list(
        initialize = function(..., creationDate = Sys.time()) {
            callSuper(
                creationDate = creationDate,
                ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            sb <- StringBuilder()
            sb$append(prefix, "random-project: ")
            sb$append(name)
            sb$append(" [", format(creationDate, "%Y-%m-%d"), "] ")
            sb$append(uniqueId)
            return(sb$toString())
        }
    )
)


