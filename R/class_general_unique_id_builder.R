# ------------------------------------------------------------------------------
#  randomforge — Innovating the Future of Randomization
#  Framework for transparent and extensible clinical trial randomization in R
#
#  Author: Friedrich Pahlke, RPACT GmbH
#  Copyright (c) 2025
#
#  This file is part of the randomforge R package.
#  The package is licensed under the GNU Lesser General Public License (LGPL-3.0).
#  Full license text: https://www.gnu.org/licenses/lgpl-3.0.txt
#
#  Source code and issue tracker:
#  https://github.com/RCONIS/randomforge
#
#  Documentation:
#  https://randomforge.org
#
#  For collaboration or contributions:
#  friedrich.pahlke@rpact.com
#  info@randomforge.org
# ------------------------------------------------------------------------------

#'
#' GeneralUniqueIdBuilder Reference Class
#'
#' @description
#' Provides a builder for generating and tracking unique IDs using 
#' the `uuid` package, ensuring no duplicates within the session.
#'
#' @field uniqueIds Character vector storing all generated unique IDs.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(uniqueIds = character(0), ...)}{Initializes a 
#'     new `GeneralUniqueIdBuilder` instance and checks for the `uuid` package.}
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
            .self$uniqueIds <- c(uniqueIds, uniqueId)
            return(uniqueId)
        }
    )
)

