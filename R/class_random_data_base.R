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
#' Display a List of Objects with a Title
#'
#' @description
#' Formats and returns a string representation of a list of objects, each displayed using their `toString` method, prefixed by a title.
#'
#' @param x List of objects to display.
#' @param title Character string used as the title for the list.
#'
#' @return A character string representing the formatted list, or an empty character vector if the list is empty or `NULL`.
#'
#' @keywords internal
#' @noRd
#' 
.showList <- function(x, title) {
    if (is.null(x) || length(x) == 0) {
        return(character(0))
    }
    sb <- StringBuilder()
    sb$append(title, ":\n")
    for (entry in x) {
        sb$append(entry$toString(prefix = "\t"), "\n")
    }
    return(sb$toString())
}

#'
#' Create a New RandomDataBase Instance
#'
#' @description
#' Constructs and returns a new `RandomDataBase` reference class object, 
#' initializing all fields and assigning a unique ID.
#'
#' @return A `RandomDataBase` reference class object.
#' 
#' @seealso \code{\link[=RandomDataBase]{RandomDataBase}}
#' @seealso \code{\link[=as.data.frame.RandomDataBase]{as.data.frame()}}
#'
#' @export
#' 
getRandomDataBase <- function() {
    return(RandomDataBase())
}

#'
#' RandomDataBase Reference Class
#'
#' @description
#' Manages randomization data, including projects, configurations, 
#' allocation values, subjects, and results. Provides methods for 
#' validation, persistence, retrieval, and display of randomization objects.
#'
#' @field uniqueId Character string uniquely identifying the database instance.
#' @field creationDate POSIXct timestamp of database creation.
#' @field randomProjects List of `RandomProject` objects.
#' @field randomConfigurations List of `RandomConfiguration` objects.
#' @field randomAllocationValues List of `RandomAllocationValue` objects.
#' @field randomSubjects List of `RandomSubject` objects.
#' @field randomResults List of `RandomResult` objects.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(..., creationDate)}{Initializes a new `RandomDataBase` instance, assigns a unique ID, and sets up empty lists for all fields.}
#'   \item{validateRandomProject(randomProject)}{Checks if a project exists in the database; stops with an error if not.}
#'   \item{show()}{Displays a summary of the database and its contents.}
#'   \item{toString()}{Returns a string representation of the database and its statistics.}
#'   \item{persist(obj)}{Persists an object to the appropriate list based on its class.}
#'   \item{getRandomProjectUniqueIds(objects)}{Returns a character vector of unique IDs for the given objects' projects.}
#'   \item{getLastSubject(randomProject)}{Retrieves the last subject for a given project.}
#'   \item{getLastRandomConfiguration(randomProject)}{Retrieves the last configuration for a given project.}
#'   \item{createNewSubjectRandomNumber(randomProject)}{Generates the next subject random number for a given project.}
#' }
#' 
#' @seealso \code{\link[=getRandomDataBase]{getRandomDataBase()}}
#' @seealso \code{\link[=as.data.frame.RandomDataBase]{as.data.frame()}}
#'
#' @keywords internal
#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomDataBase <- setRefClass("RandomDataBase",
    fields = list(
        uniqueId = "character",
        creationDate = "POSIXct",
        randomProjects = "list",
        randomConfigurations = "list",
        randomAllocationValues = "list",
        randomSubjects = "list",
        randomResults = "list"
    ),
    methods = list(
        initialize = function(...,
                creationDate = Sys.time()) {
            callSuper(
                creationDate = creationDate,
                ...)
            .self$uniqueId <- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
            .self$randomAllocationValues <- list()
            .self$randomConfigurations <- list()
            .self$randomSubjects <- list()
            .self$randomResults <- list()
        },
        validateRandomProject = function(randomProject) {
            for (p in .self$randomProjects) {
                if (p$uniqueId == randomProject$uniqueId) {
                    return(invisible())
                }
            }
            stop("'randomProjects' does not exist und must be persisted first")
        },
        show = function() {
            sb <- StringBuilder()
            sb$append(.self$toString(), "\n")
            sb$append(.showList(.self$randomProjects, "Random projects"))
            sb$append(.showList(.self$randomConfigurations, "Random configurations"))
            sb$append(.showList(.self$randomAllocationValues, "Random allocation values"))
            sb$append(.showList(.self$randomSubjects, "Random subjects"))
            cat(sb$toString())
            
            cat("Random system state:\n")
            for (randomResult in randomResults) {
                if (!is.null(randomResult) && !is.null(randomResult$randomSystemState)) {
                    randomResult$randomSystemState$show(prefix = "\t")
                }
            }
            cat("Random results:\n")
            for (randomResult in randomResults) {
                if (!is.null(randomResult) && !is.null(randomResult$randomSystemState)) {
                    randomResult$show(prefix = "\t")
                }
            }
        },
        toString = function() {
            sb <- StringBuilder()
            sb$append("Random data base: ")
            sb$append(uniqueId)
            sb$append(" [")
            sb$append("randomAllocationValues: ", length(.self$randomAllocationValues), ", ")
            sb$append(".self$randomConfigurations: ", length(.self$randomConfigurations), ", ")
            sb$append(".self$randomSubjects: ", length(.self$randomSubjects))
            sb$append("]")
            return(sb$toString())
        },
        persist = function(obj) {
            if (inherits(obj, "RandomAllocationValue")) {
                .self$randomAllocationValues[[length(.self$randomAllocationValues) + 1]] <- obj
            }
            else if (inherits(obj, "RandomConfiguration")) {
                .self$randomConfigurations[[length(.self$randomConfigurations) + 1]] <- obj
            }
            else if (inherits(obj, "RandomSubject")) {
                .self$randomSubjects[[length(.self$randomSubjects) + 1]] <- obj
            }
            else if (inherits(obj, "RandomResult")) {
                .self$randomResults[[length(.self$randomResults) + 1]] <- obj
            }
            else if (inherits(obj, "RandomProject")) {
                .self$randomProjects[[length(.self$randomProjects) + 1]] <- obj
            }
        },
        getRandomProjectUniqueIds = function(objects) {
            uniqueIds <- character(0)
            for (obj in objects) {
                uniqueIds <- c(uniqueIds, obj$randomProject$uniqueId)
            }
            return(uniqueIds)
        },
        getLastSubject = function(randomProject) {
            if (length(.self$randomSubjects) == 0) {
                return(NULL)
            }
            
            s <- .self$randomSubjects[getRandomProjectUniqueIds(.self$randomSubjects) == randomProject$uniqueId]
            if (length(s) == 0) {
                return(NULL)
            }
            
            return(s[[length(s)]])
        },
        getLastRandomConfiguration = function(randomProject) {
            if (length(.self$randomConfigurations) == 0) {
                return(NULL)
            }
            
            configs <- .self$randomConfigurations[getRandomProjectUniqueIds(.self$randomConfigurations) == randomProject$uniqueId]
            if (length(configs) == 0) {
                return(NULL)
            }
            
            return(configs[[length(configs)]])
        },
        createNewSubjectRandomNumber = function(randomProject) {
            if (length(.self$randomSubjects) == 0) {
                return(1L)
            }
            
            randomNumber <- 1L
            for (randomSubject in .self$randomSubjects) {
                if (randomSubject$randomProject$uniqueId == randomProject$uniqueId &&
                        randomSubject$randomNumber > randomNumber) {
                    randomNumber <- randomSubject$randomNumber
                }
            }
            return(randomNumber + 1L)
        }
    )
)

#'
#' Convert RandomDataBase Subjects to Data Frame
#'
#' @description
#' Converts the list of `RandomSubject` objects stored in a `RandomDataBase` instance into a data frame by applying `as.data.frame` to each subject and binding the results by row.
#'
#' @param x A `RandomDataBase` reference class object.
#' @param ... Additional arguments passed to `as.data.frame`.
#'
#' @return A data frame containing all subjects from the database.
#' 
#' @seealso \code{\link[=RandomDataBase]{RandomDataBase}}
#'
#' @export
#' 
as.data.frame.RandomDataBase <- function(x, ...) {
    do.call(rbind.data.frame, lapply(x$randomSubjects, as.data.frame))
}
