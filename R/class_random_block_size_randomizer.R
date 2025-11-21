
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
#' @export
#' 
getRandomBlockSizeRandomizer <- function(blockSizes, ..., seed = NA_integer_) {
    .assertIsSingleInteger(seed, "seed", naAllowed = TRUE, validateType = FALSE)
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
                .self$seed <- .getRandomSeed()
            }
            .setSeed(.self$seed)
            .self$index <- 1L
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return("RandomBlockSizeRandomizer(seed = ", .self$seed, 
                   ", numberOfValues = ", length(.self$values), 
                   ", currentIndex = ", .self$index, ")")
        },
        initRandomValues = function(numberOfBlockSizes, ..., numberOfValuesToCreate = 1000L) {
            values <<- sample.int(n = numberOfBlockSizes, size = numberOfValuesToCreate, replace = TRUE)
        },
        nextInt = function(numberOfBlockSizes) { # TODO implement numberOfBlockSizes
            if (length(values) == 0) {
                stop("Block size randomizer not initialized. Call initRandomValues() first")
            }
            if (index > length(values)) {
                stop("No more random block sizes available")
            }
            
            value <- values[index]
            index <<- index + 1L
            return(value)
        }
    )
)
