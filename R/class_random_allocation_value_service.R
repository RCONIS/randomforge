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
#' Create a New RandomAllocationValueService Instance
#'
#' @description
#' Constructs and returns a new `RandomAllocationValueService` reference 
#' class object, which manages the generation and retrieval of random 
#' allocation values for randomization procedures.
#'
#' @return A `RandomAllocationValueService` reference class object.
#' 
#' @seealso \code{\link[=RandomAllocationValueService]{RandomAllocationValueService}}
#'
#' @export
#' 
getRandomAllocationValueService <- function() {
    return(RandomAllocationValueService())
}

#'
#' RandomAllocationValueService Reference Class
#'
#' @description
#' Manages the generation and retrieval of random allocation values for 
#' randomization procedures. Maintains a reproducible sequence of random 
#' values using a seed, and provides methods for initialization, 
#' value creation, retrieval, and display.
#'
#' @field seed Integer random seed used for reproducibility.
#' @field index Integer index tracking the current position in the values vector.
#' @field values Numeric vector of generated random allocation values.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(...)}{Initializes the service, setting the seed, index, and values.}
#'   \item{show()}{Displays a summary of the service.}
#'   \item{toString()}{Returns a string representation of the service.}
#'   \item{createNewRandomAllocationValues(randomConfiguration)}{
#'     Generates new random allocation values 
#'     based on the configuration.}
#'   \item{getNextRandomAllocationValue(randomConfiguration)}{Retrieves 
#'     the next random allocation value if available.}
#' }
#' 
#' @seealso \code{\link[=plot.RandomAllocationValueService]{plot()}}
#'
#' @export
#' 
RandomAllocationValueService <- setRefClass("RandomAllocationValueService",
    fields = list(
        seed = "integer",
        index = "integer",
        values = "numeric"
    ),
    methods = list(
        initialize = function(...) {
            callSuper(...)
            .self$seed <- NA_integer_ 
            .self$index <- 1L 
            .self$values <- numeric(0)
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return("RandomAllocationValueService")
        },
        createNewRandomAllocationValues = function(randomConfiguration) {
            numberOfValuesToCreate <- randomConfiguration$ravBufferMaximumSize - randomConfiguration$ravBufferMinimumSize
            if (is.na(numberOfValuesToCreate) || numberOfValuesToCreate < 1) {
                stop("Runtime issue: rav buffer range [", randomConfiguration$ravBufferMinimumSize, 
                    " - ", randomConfiguration$ravBufferMaximumSize, "] is invalid")
            }
            
            if (is.na(seed) || length(.self$values) == 0) {
                .self$seed <- randomConfiguration$getSeed()
                .setSeed(seed)
                seedInfo <- seed
            } else if (length(.self$values) > 0) {
                seed2 <- as.integer(trunc(.self$values[length(.self$values)] * 0.333 * 1e08))
                .setSeed(seed2)
                seedInfo <- seed2
            }
            
            message("Create ", numberOfValuesToCreate, " new random allocation values (seed = ", seedInfo, ")")
            
            .self$values <- c(.self$values, stats::runif(numberOfValuesToCreate))
        },
        getNextRandomAllocationValue = function(randomConfiguration) {
            numberOfFreeValues <- length(values) - .self$index
            if (numberOfFreeValues < randomConfiguration$ravBufferMinimumSize) {
                return(NULL)
            }
            
            doubleValue <- values[.self$index]
            rav <- RandomAllocationValue(doubleValue = doubleValue)
            .self$index <- .self$index + 1L
            return(rav)
        }
    )
)

#'
#' Plot Distribution of Random Allocation Values
#'
#' @description
#' Visualizes the distribution of random allocation values managed by 
#' a `RandomAllocationValueService` object. Optionally restricts the plot 
#' to only used values and performs a chi-squared test for uniformity.
#'
#' @param x A `RandomAllocationValueService` object.
#' @param ... Additional arguments passed to the `hist` function.
#' @param usedValuesOnly Logical; if `TRUE`, only values up to the current index are plotted.
#'
#' @return A histogram plot of the random allocation values.
#'
#' @export
#' 
plot.RandomAllocationValueService <- function(x, ..., usedValuesOnly = TRUE) {
    values <- x$values
    if (is.null(values) || length(values) == 0) {
        stop("'RandomAllocationValueService' is not initialized. Run createNewRandomAllocationValues() first")
    }
    
    if (usedValuesOnly) {
        if (x$index <= 1) {
            stop(C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, 
                "plot argument usedValuesOnly = FALSE is required because no random allocation values have beed used")
        }
        
        values <- values[seq_len(x$index)]
    }
    
    suppressWarnings(chisq <- stats::chisq.test(values))
    main <- paste0("Distribution of ", ifelse(usedValuesOnly, "used ", ""), "random allocation values")
    graphics::hist(values, main = main, 
        xlab = paste0("Random value (N = ", length(values), 
        "; mean = ", round(mean(values), 4), 
        "; p = ", round(chisq$p.value, 4), ")"))
}


