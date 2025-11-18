
#' @export 
getRandomAllocationValueService <- function() {
    return(RandomAllocationValueService())
}

#'
#' 
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

#' @export 
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


