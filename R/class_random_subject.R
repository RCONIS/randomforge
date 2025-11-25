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
#' RandomSubject Reference Class
#'
#' @description
#' Represents a subject in the randomization system, including unique 
#' identifier, project association, random number, factor levels, 
#' randomization result, and status.
#'
#' @field uniqueId Character string uniquely identifying the subject.
#' @field randomProject `RandomProject` object associated with the subject.
#' @field randomNumber Integer representing the subject's random number.
#' @field factorLevels List of factor levels for the subject.
#' @field randomResult `RandomResult` object containing the randomization outcome.
#' @field status Character string indicating the subject's status.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(...)}{Initializes a new `RandomSubject` instance and assigns a unique ID.}
#'   \item{show(prefix = "")}{Prints a summary of the subject.}
#'   \item{toString(prefix = "")}{Returns a string representation of the subject.}
#'   \item{setStatus(status)}{Sets the subject's status.}
#' }
#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' @include class_random_project.R
#' @include class_random_result.R
#' 
#' @seealso \code{\link[=as.data.frame.RandomSubject]{as.data.frame()}}
#'
#' @keywords internal
#' 
#' @export
#' 
RandomSubject <- setRefClass("RandomSubject",
    fields = list(
        uniqueId = "character",
        randomProject = "RandomProject",
        randomNumber = "integer",
        factorLevels = "list",
        randomResult = "RandomResult",
        status = "character"
    ),
    methods = list(
        initialize = function(...) {
            callSuper(...)
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
        },
        show = function(prefix = "") {
            cat(toString(prefix = prefix), "\n")
        },
        toString = function(prefix = "") {
            sb <- StringBuilder()
            sb$append(prefix, "subject:")
            sb$append(.self$randomNumber)
            if (!is.null(.self$randomResult)) {
                sb$append("[", .self$randomResult$toString(), "]")
            }
            if (!is.null(.self$status) && nchar(.self$status) > 0) {
                sb$append(" ", .self$status)
            }
            return(sb$toString())
        },
        setStatus = function(status) {
            .self$status <- status
        }
    )
)

#'
#' Convert RandomSubject to Data Frame
#'
#' @description
#' Converts a `RandomSubject` object into a data frame containing project, 
#' random number, treatment arm, status, system state, 
#' randomization decision, and unique subject ID.
#'
#' @param x A `RandomSubject` object.
#' @param ... Additional arguments (currently unused).
#'
#' @return A data frame with columns for subject and randomization details.
#'
#' @keywords internal
#' 
#' @seealso \code{\link[=RandomSubject]{RandomSubject}}
#' 
#' @export
#'  
as.data.frame.RandomSubject <- function(x, ...) {
    df <- data.frame(
        "project" = x$randomProject$name,
        "random-number" = x$randomNumber,
        "treatment-arm" = x$randomResult$treatmentArmId,
        "status" = x$status
    )
    df <- cbind(df, as.data.frame(x$randomResult$randomSystemState))
    df <- cbind(df, data.frame(
        "randomization-decision" = x$randomResult$randomMethodRangeSet$toString(),
        "unique-subject-id" = x$uniqueId
    ))
    colnames(df) <- gsub("\\.", "-", colnames(df))
    return(df)
}