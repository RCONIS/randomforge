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
#' RandomResult Reference Class
#'
#' @description
#' Represents the outcome of a randomization, including treatment assignment, system state, and method range set at the time of randomization.
#'
#' @field uniqueId Character string uniquely identifying the randomization result.
#' @field randomizationDate POSIXct timestamp of the randomization.
#' @field treatmentArmId Character string indicating the assigned treatment arm.
#' @field randomSystemState `RandomSystemState` object representing the system state at randomization.
#' @field randomMethodRangeSet `RandomMethodRangeSet` object representing the method range set used.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., randomizationDate = Sys.time())}{Initializes a new `RandomResult` instance and assigns a unique ID.}
#'   \item{show(prefix = "")}{Prints a summary of the randomization result.}
#'   \item{toString(prefix = "")}{Returns a string representation of the randomization result.}
#' }
#'
#' @keywords internal
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
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
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
