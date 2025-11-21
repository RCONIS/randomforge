
#'
#' Create a New RandomConfiguration Instance
#'
#' @description
#' Constructs and returns a new `RandomConfiguration` reference class object, 
#' initializing all fields and assigning a unique ID. Allows specification of 
#' treatment arms, seed, buffer sizes, and associated project.
#'
#' @param ... Additional arguments passed to the constructor.
#' @param randomProject `RandomProject` object associated with this configuration.
#' @param treatmentArmIds Character vector of treatment arm IDs.
#' @param seed Integer random seed used for reproducibility. Defaults to `NA_integer_`.
#' @param ravBufferMinimumSize Integer specifying the minimum buffer size for allocation values. Defaults to `1000L`.
#' @param ravBufferMaximumSize Integer specifying the maximum buffer size for allocation values. Defaults to `10000L`.
#'
#' @return A `RandomConfiguration` reference class object.
#' 
#' @seealso \code{\link[=RandomConfiguration]{RandomConfiguration}}
#'
#' @export
#' 
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
#' RandomConfiguration Reference Class
#'
#' @description
#' Represents a randomization configuration for a project, including 
#' treatment arms, seed, buffer sizes, and optional factor IDs. 
#' Provides methods for initialization, display, and validation of configuration parameters.
#'
#' @field uniqueId Character string uniquely identifying the configuration instance.
#' @field creationDate POSIXct timestamp of configuration creation.
#' @field randomProject `RandomProject` object associated with this configuration.
#' @field seed Integer random seed used for reproducibility.
#' @field ravBufferMinimumSize Integer specifying the minimum buffer size for allocation values.
#' @field ravBufferMaximumSize Integer specifying the maximum buffer size for allocation values.
#' @field treatmentArmIds Character vector of treatment arm IDs.
#' @field factorIds Character vector of factor IDs (optional).
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., creationDate, seed, ravBufferMinimumSize, 
#'     ravBufferMaximumSize)}{Initializes a new `RandomConfiguration` instance, 
#'     validates buffer sizes, assigns a unique ID, and sets the seed.}
#'   \item{show(prefix)}{Displays a summary of the configuration.}
#'   \item{toString(prefix)}{Returns a string representation of the configuration and its fields.}
#'   \item{getDoubleValue()}{Returns the double value (if defined).}
#'   \item{getSeed()}{Returns the seed value, validating its integrity.}
#' }
#' 
#' @seealso \code{\link[=getRandomConfiguration]{getRandomConfiguration()}}
#'
#' @keywords internal
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
                stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
                    "ravBufferMinimumSize (", ravBufferMinimumSize, ") must be > 0")
            }
            if (ravBufferMaximumSize <= ravBufferMinimumSize) {
                stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
                    "ravBufferMaximumSize (", ravBufferMaximumSize, 
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
                stop(C_EXCEPTION_TYPE_RUNTIME_ISSUE, "seed is invalid")
            }
            return(seed)
        }
    )
)


