
#' @export 
getRandomBlockSizeRandomizer <- function() {
    return(RandomBlockSizeRandomizer())
}

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
