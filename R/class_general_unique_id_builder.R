

#'
#' GeneralUniqueIdBuilder Reference Class
#'
#' @description
#' Provides a builder for generating and tracking unique IDs using the `uuid` package, ensuring no duplicates within the session.
#'
#' @field uniqueIds Character vector storing all generated unique IDs.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(uniqueIds = character(0), ...)}{Initializes a new `GeneralUniqueIdBuilder` instance and checks for the `uuid` package.}
#'   \item{show()}{Prints a summary of the builder.}
#'   \item{toString()}{Returns a string representation of the builder.}
#'   \item{getUniqueId()}{Generates a new unique ID and adds it to the tracked list.}
#' }
#' 
#' @include f_assertions.R
#'
#' @keywords internal
#' 
#' @noRd
#' 
GeneralUniqueIdBuilder <- setRefClass("GeneralUniqueIdBuilder",
    fields = list(
        uniqueIds = "character"
    ),
    methods = list(
        initialize = function(uniqueIds = character(0), ...) {
            callSuper(uniqueIds = uniqueIds, ...)
            .assertPackageIsInstalled("uuid")
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return("GeneralUniqueIdObjectBuilder")
        },
        getUniqueId = function() {
            uniqueId <- NA_character_
            while (is.na(uniqueId) || uniqueId %in% uniqueIds) {
                uniqueId <- uuid::UUIDgenerate()
            }
            uniqueIds <<- c(uniqueIds, uniqueId)
            return(uniqueId)
        }
    )
)

