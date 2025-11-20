
#'
#' Create a New RandomBlockSizeRandomizer Instance
#'
#' @description
#' Constructs and returns a new `RandomBlockSizeRandomizer` reference 
#' class object, which manages random selection of block sizes for 
#' randomization procedures.
#'
#' @return A `RandomBlockSizeRandomizer` reference class object.
#'
#' @export
#' 
getRandomBlockSizeRandomizer <- function() {
    return(RandomBlockSizeRandomizer())
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
            index <<- 1L
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            return("RandomBlockSizeRandomizer")
        },
        initRandomValues = function(numberOfBlockSizes, numberOfValuesToCreate = 1000L) {
            if (is.na(seed)) {
                seed <<- .getRandomSeed()
                .setSeed(seed)
            }
            values <<- sample.int(n = numberOfBlockSizes, size = numberOfValuesToCreate, replace = TRUE)
        },
        nextInt = function(numberOfBlockSizes) { # TODO numberOfBlockSizes
            if (index > length(values)) {
                stop("Index out of bounds exception: index (", index, ") is out of bounds [1; ", length(values), "]")
            }
            
            value <- values[index]
            index <<- index + 1L
            return(value)
        }
    )
)
