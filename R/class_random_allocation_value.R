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
#' RandomAllocationValue Reference Class
#'
#' @description
#' Represents a single random allocation value, including its unique 
#' identifier, configuration, creation date, numeric value, associated 
#' result, and hash. Provides methods for initialization, display, 
#' string conversion, and value retrieval.
#'
#' @field uniqueId Character unique identifier for the allocation value.
#' @field randomConfiguration `RandomConfiguration` object describing the randomization setup.
#' @field creationDate POSIXct timestamp of creation.
#' @field doubleValue Numeric value representing the allocation.
#' @field randomResult `RandomResult` object associated with the allocation.
#' @field hashValue Integer hash of the allocation value.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., creationDate = Sys.time())}{Initializes a 
#'     new `RandomAllocationValue` instance, setting the creation date and generating a unique ID.}
#'   \item{show(prefix = "")}{Displays a summary of the allocation value.}
#'   \item{toString(prefix = "")}{Returns a string representation of the allocation value.}
#'   \item{getDoubleValue()}{Returns the numeric allocation value.}
#' }
#'
#' @keywords internal
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
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            return(paste0(prefix, "rav:", .self$doubleValue))
        },
        getDoubleValue = function() {
            return(.self$doubleValue)
        }
    )
)

