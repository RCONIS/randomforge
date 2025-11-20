
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
#'   \item{createNewRandomAllocationValues(randomConfiguration, 
#'     numberOfValuesToCreate)}{Generates new random allocation values 
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
            seed <<- NA_integer_ 
            index <<- 1L 
            values <<- numeric(0)
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return("RandomAllocationValueService")
        },
        createNewRandomAllocationValues = function(
                randomConfiguration, 
                numberOfValuesToCreate) {
            
            n <- randomConfiguration$ravBufferMaximumSize - randomConfiguration$ravBufferMinimumSize
            if (is.na(n) || n < 1) {
                stop("Runtime issue: rav buffer range [", randomConfiguration$ravBufferMinimumSize, 
                    " - ", randomConfiguration$ravBufferMaximumSize, "] is invalid")
            }
            
            if (is.na(seed) || length(values) == 0) {
                seed <<- randomConfiguration$getSeed()
                .setSeed(seed)
                seedInfo <- seed
            } else if (length(values) > 0) {
                seed2 <- as.integer(trunc(values[length(values)] * 0.333 * 1e08))
                .setSeed(seed2)
                seedInfo <- seed2
            }
            
            message("Create ", n, " new random allocation values (seed = ", seedInfo, ")")
            
            values <<- c(values, stats::runif(n))
        },
        getNextRandomAllocationValue = function(randomConfiguration) {
            numberOfFreeValues <- length(values) - index
            if (numberOfFreeValues < randomConfiguration$ravBufferMinimumSize) {
                return(NULL)
            }
            
            doubleValue <- values[index]
            rav <- RandomAllocationValue(doubleValue = doubleValue)
            index <<- index + 1L
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
    if (usedValuesOnly) {
        values <- values[1:x$index]
    }
    suppressWarnings(chisq <- chisq.test(values))
    main <- paste0("Distribution of ", ifelse(usedValuesOnly, "used ", ""), "random allocation values")
    hist(values, main = main, 
        xlab = paste0("Random value (N = ", length(values), 
        "; mean = ", round(mean(values), 4), 
        "; p = ", round(chisq$p.value, 4), ")"))
}


