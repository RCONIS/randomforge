
#'
#' Generate or Retrieve a Random Seed
#'
#' @description
#' Retrieves the current random seed from the global environment if available, 
#' or generates a new random seed using a uniform distribution. Ensures the 
#' seed is a valid single integer.
#' 
#' @param maxValue a single integer value. The maximum value that the seed can have, default is \code{99999999}.
#'
#' @return An integer representing the random seed.
#'
#' @keywords internal
#'  
#' @noRd
#' 
.getRandomSeed <- function(maxValue = 99999999) {
    if (exists(".Random.seed") && length(.Random.seed) > 0) {
        seed <- as.integer(.Random.seed[length(.Random.seed)])
    } else {
        seed <- as.integer(trunc(stats::runif(1) * 1e09))
    }
    
    if (is.null(seed) || length(seed) != 1 || is.na(seed)) {
        seed <- as.integer(trunc(stats::runif(1) * 1e08))
    }
    
    if (is.null(seed) || length(seed) != 1 || is.na(seed)) {
        seed <- as.integer(Sys.time())
    }
    
    while (seed > maxValue) {
        seedText <- as.character(seed)
        n <- nchar(seedText)
        seed <- as.integer(substring(seedText, max(2, n - 8), n))
    }
    
    return(seed)
}

#'
#' @title
#' Create Seed
#'
#' @description
#' Returns one or more true random numbers which can be used as seed.
#'
#' @param numberOfValues a single integer value. Number of seeds to create, default is \code{1}.
#' @param minValue a single integer value. The minimum value that a seed can have, default is \code{1000000}.
#' @param maxValue a single integer value. The maximum value that a seed can have, default is \code{9999999}.
#' @param ... optional arguments.
#'
#' @details
#' RANDOM.ORG offers true random numbers to anyone on the Internet.
#' The randomness comes from atmospheric noise, which for many purposes
#' is better than the pseudo-random number algorithms typically used
#' in computer programs. For more information see \url{https://www.random.org}.
#'
#' @seealso \link{getSimulatedTwoArmMeans}
#'
#' @return an integer value or vector containing one or more seeds.
#'
#' @export
#'
createSeed <- function(numberOfValues = 1, minValue = 1000000, maxValue = 9999999, ...) {
    .assertPackageIsInstalled("httr")
    .assertPackageIsInstalled("glue")
    .assertIsSingleInteger(numberOfValues, "numberOfValues", validateType = FALSE)
    .assertIsInClosedInterval(numberOfValues, "numberOfValues", lower = 1, upper = 1000)
    .assertIsSingleInteger(minValue, "minValue", validateType = FALSE)
    .assertIsInClosedInterval(minValue, "minValue", lower = 1, upper = 100000000)
    .assertIsSingleInteger(maxValue, "maxValue", validateType = FALSE)
    .assertIsInClosedInterval(maxValue, "maxValue", lower = 1, upper = 999999999)
    if (minValue >= maxValue) {
        stop(C_EXCEPTION_TYPE_CONFLICTING_ARGUMENTS, "'minValue' (", minValue, ") ",
            "must be smaller than argument 'maxValue'(", maxValue, ")")
    }
    tryCatch(
        {
            args <- list(...)
            if (length(args) > 0 && !is.null(args[["test_exception"]])) {
                stop(args[["test_exception"]])
            }
            
            minValue <- as.integer(minValue)
            maxValue <- as.integer(maxValue)
            url <- glue::glue(paste0(
                "https://www.random.org/integers/",
                "?num={numberOfValues}",
                "&min={minValue}",
                "&max={maxValue}",
                "&col=1",
                "&base=10",
                "&format=plain",
                "&rnd=new"
            ))
            
            response <- httr::GET(url)
            response <- httr::content(response)
            response <- trimws(response)
            response <- strsplit(response, "\n")
            response <- unlist(response)
            return(as.integer(response))
        },
        error = function(e) {
            warning("Failed to receive new seed from www.random.org: ", e$message)
            return(.getRandomSeed(maxValue))
        }
    )
}