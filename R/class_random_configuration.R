

#' @export 
getRandomConfiguration <- function(..., 
        randomProject, treatmentArmIds, 
        seed = NA_integer_,
        ravBufferMinimumSize = 1000L,
        ravBufferMaximumSize = 10000L) {
    return(RandomConfiguration(randomProject = randomProject, 
        treatmentArmIds = treatmentArmIds,
        seed = as.integer(seed),
        ravBufferMinimumSize = ravBufferMinimumSize,
        ravBufferMaximumSize = ravBufferMaximumSize
    ))
}

#' 
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' @include f_utilities.R
#' @include class_random_project.R
#' 
RandomConfiguration <- setRefClass("RandomConfiguration",
    fields = list(
        uniqueId = "character",
        creationDate = "POSIXct",
        randomProject = "RandomProject",
        seed = "integer",
        ravBufferMinimumSize = "integer",
        ravBufferMaximumSize = "integer",
        treatmentArmIds = "character",
        factorIds = "character"
    ),
    methods = list(
        initialize = function(...,
                creationDate = Sys.time(),
                seed = NA_integer_,
                ravBufferMinimumSize = 1000L,
                ravBufferMaximumSize = 10000L
            ) {
            callSuper(
                creationDate = creationDate,
                seed = seed,
                ravBufferMinimumSize = ravBufferMinimumSize, 
                ravBufferMaximumSize = ravBufferMaximumSize, 
                ...)
            if (ravBufferMinimumSize < 1) {
                stop("Illegal argument: ravBufferMinimumSize (", ravBufferMinimumSize, ") must be > 0")
            }
            if (ravBufferMaximumSize <= ravBufferMinimumSize) {
                stop("Illegal argument: ravBufferMaximumSize (", ravBufferMaximumSize, 
                    ") must be greater than ravBufferMinimumSize (", ravBufferMinimumSize, ")")
            }
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
            if (is.na(seed)) {
                seed <<- .getRandomSeed()
            }
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            sb <- StringBuilder()
            sb$append(prefix, randomProject$toString(), "\n")
            sb$append(prefix, "uniqueId: ", uniqueId, "\n")
            sb$append(prefix, "creationDate: ", format(creationDate, "%Y-%m-%d"), "\n")
            sb$append(prefix, "seed: ", seed, "\n")
            sb$append(prefix, "ravBufferMinimumSize: ", ravBufferMinimumSize, "\n")
            sb$append(prefix, "ravBufferMaximumSize: ", ravBufferMaximumSize, "\n")
            sb$append(prefix, "treatmentArmIds: ", .arrayToString(sQuote(treatmentArmIds)))
            if (!is.null(factorIds) && length(factorIds) > 0) {
                sb$append("\n")
                sb$append(prefix, "factorIds: ", .arrayToString(factorIds))
            }
            return(sb$toString())
        },
        getDoubleValue = function() {
            return(doubleValue)
        },
        getSeed = function() {
            if (is.null(seed) || length(seed) != 1 || is.na(seed)) {
                stop("Runtime exception: seed is invalid")
            }
            return(seed)
        }
    )
)


