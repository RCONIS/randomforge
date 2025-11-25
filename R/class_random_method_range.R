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
#' RandomMethodRange Reference Class
#'
#' @description
#' Represents a range for randomization methods, associated with a treatment arm and defined by lower and upper bounds.
#'
#' @field uniqueId Character string uniquely identifying the method range.
#' @field treatmentArmId Character string specifying the treatment arm.
#' @field lowerBound Numeric value for the lower bound of the range.
#' @field upperBound Numeric value for the upper bound of the range.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., treatmentArmId, lowerBound, upperBound)}{Initializes a new `RandomMethodRange` instance and assigns a unique ID.}
#'   \item{show()}{Prints a string representation of the method range.}
#'   \item{toString(randomAllocationValue = NULL)}{Returns a string representation of the range, optionally including a specific allocation value.}
#'   \item{contains(value)}{Checks if a value falls within the defined range.}
#' }
#'
#' @keywords internal
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
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
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


