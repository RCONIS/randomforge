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
#' Create a RandomProject Instance
#'
#' @description
#' Instantiates a new `RandomProject` object with the specified project name.
#'
#' @param name Character string specifying the project name.
#'
#' @return A `RandomProject` reference class object.
#' 
#' @seealso \code{\link[=RandomProject]{RandomProject}}
#'
#' @export
#' 
getRandomProject <- function(name) {
    return(RandomProject(name = name))
}

#'
#' RandomProject Reference Class
#'
#' @description
#' Represents a randomization project, including a unique identifier, project name, and creation date.
#'
#' @field uniqueId Character string uniquely identifying the project.
#' @field name Character string specifying the project name.
#' @field creationDate POSIXct timestamp of project creation.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., creationDate = Sys.time())}{Initializes a new `RandomProject` instance and assigns a unique ID.}
#'   \item{show(prefix = "")}{Prints a summary of the project.}
#'   \item{toString(prefix = "")}{Returns a string representation of the project.}
#' }
#'
#' @keywords internal
#' 
#' @seealso \code{\link[=getRandomProject]{getRandomProject()}}
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
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
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


