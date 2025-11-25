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
#' Create a New RandomBlockSizeRandomizer Instance
#'
#' @description
#' Constructs and returns a new `RandomBlockSizeRandomizer` reference 
#' class object, which manages random selection of block sizes for 
#' randomization procedures.
#' 
#' @param blockSizes List of block size configurations, each mapping treatment arm IDs to sizes.
#' @param seed Integer random seed used for reproducibility.
#'
#' @return A `RandomBlockSizeRandomizer` reference class object.
#' 
#' @seealso \code{\link[=RandomBlockSizeRandomizer]{RandomBlockSizeRandomizer}}
#'
#' @include f_seed.R
#' 
#' @export
#' 
getRandomBlockSizeRandomizer <- function(blockSizes, ..., seed = NA_integer_) {
    .assertIsSingleInteger(seed, "seed", naAllowed = TRUE, validateType = FALSE)
    if (!exists("blockSizes")) {
        stop(C_EXCEPTION_TYPE_MISSING_ARGUMENT, "'blockSizes' must be specified")
    }
    if (is.na(seed)) {
        seed <- createSeed()
    }
    blockSizeRandomizer <- RandomBlockSizeRandomizer(seed = as.integer(seed))
    blockSizeRandomizer$initRandomValues(numberOfBlockSizes = length(blockSizes))
    return(blockSizeRandomizer)
}

#'
#' RandomBlockSizeRandomizer Reference Class
#'
#' @description
#' Manages random selection of block sizes for randomization procedures. 
#' Maintains a reproducible sequence of block sizes using a seed, and 
#' provides methods for initialization, value generation, and retrieval.
#'
#' @field seed Integer random seed used for reproducibility.
#' @field values Integer vector of randomly generated block sizes.
#' @field index Integer index tracking the current position in the values vector.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(seed, ...)}{Initializes the randomizer with a seed and sets the index to 1.}
#'   \item{show()}{Displays a summary of the randomizer.}
#'   \item{toString()}{Returns a string representation of the randomizer.}
#'   \item{initRandomValues(numberOfBlockSizes, numberOfValuesToCreate)}{Generates a sequence of random block sizes.}
#'   \item{nextInt(numberOfBlockSizes)}{Retrieves the next random block size from the sequence.}
#' }
#' 
#' @seealso \code{\link[=getRandomBlockSizeRandomizer]{getRandomBlockSizeRandomizer()}}
#'
#' @include f_seed.R
#' 
#' @keywords internal
#' 
RandomBlockSizeRandomizer <- setRefClass("RandomBlockSizeRandomizer",
    fields = list(
        seed = "integer",
        values = "integer",
        index = "integer"
    ),
    methods = list(
        initialize = function(seed = NA_integer_, ...) {
            callSuper(seed = seed, ...)
            if (is.na(seed)) {
                .self$seed <- createSeed()
            }
            .setSeed(.self$seed)
            .self$index <- 1L
            .self$values <- integer(0)
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return(paste0("RandomBlockSizeRandomizer(seed = ", .self$seed, 
                   ", numberOfValues = ", length(.self$values), 
                   ", currentIndex = ", .self$index, ")"))
        },
        initRandomValues = function(numberOfBlockSizes, ..., numberOfValuesToCreate = 1000L) {
            .self$values <- sample.int(n = numberOfBlockSizes, size = numberOfValuesToCreate, replace = TRUE)
        },
        nextInt = function(numberOfBlockSizes) { # TODO implement numberOfBlockSizes
            if (length(values) == 0) {
                stop("Block size randomizer not initialized. Call initRandomValues() first")
            }
            if (index > length(values)) {
                stop("No more random block sizes available")
            }
            
            value <- values[index]
            .self$index <- index + 1L
            return(value)
        }
    )
)
