

#'
#' RandomMethodRangeSet Reference Class
#'
#' @description
#' Represents a set of randomization method ranges, each associated with a treatment arm and probability, and provides methods for initialization, validation, and lookup.
#'
#' @field uniqueId Character string uniquely identifying the range set.
#' @field ranges List of `RandomMethodRange` objects, keyed by treatment arm ID.
#' @field randomAllocationDoubleValue Numeric value representing the last allocation value used.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(ranges = list(), ...)}{Initializes a new `RandomMethodRangeSet` instance and assigns a unique ID.}
#'   \item{show()}{Prints a string representation of the range set.}
#'   \item{toString()}{Returns a string representation of the range set.}
#'   \item{getRange(treatmentArmId)}{Retrieves the range for a specified treatment arm.}
#'   \item{indexOf(randomAllocationValue)}{Finds the treatment arm for a given allocation value.}
#'   \item{initRanges(probabilities)}{Initializes ranges based on a named list of probabilities.}
#'   \item{validate()}{Validates that the ranges are contiguous and sum to 1.0.}
#' }
#'
#' @keywords internal
#' 
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomMethodRangeSet <- setRefClass("RandomMethodRangeSet",
    fields = list(
        uniqueId = "character",
        ranges = "list",
        randomAllocationDoubleValue = "numeric"
    ),
    methods = list(
        initialize = function(ranges = list(), ...) {
            callSuper(ranges = ranges, ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
            randomAllocationDoubleValue <<- NA_real_
        },
        show = function() {
            cat(toString(), "\n")
        },
        toString = function() {
            sb <- StringBuilder()
            for (treatmentArmId in names(ranges)) {
                if (!sb$isEmpty()) {
                    sb$append(", ")
                }
                sb$append(treatmentArmId)
                sb$append("=")
                sb$append(ranges[[treatmentArmId]]$toString())
            }
            sb$insert(1, "range-set[")
            if (!is.na(randomAllocationDoubleValue)) {
                sb$append("; rav=", randomAllocationDoubleValue)
            }
            sb$append("]")
            return(sb$toString())
        },
        getRange = function(treatmentArmId) {
            return(ranges[[treatmentArmId]])
        },
        indexOf = function(randomAllocationValue) {
            for (treatmentArmId in names(ranges)) {
                if (ranges[[treatmentArmId]]$contains(randomAllocationValue$doubleValue)) {
                    randomAllocationDoubleValue <<- randomAllocationValue$doubleValue
                    return(treatmentArmId)
                }
            }
    
            stop("The random allocation value ", randomAllocationValue$toString(), " ",
                "is not inside the ranges");
        },
        initRanges = function(probabilities) {
            if (is.null(probabilities)) {
                stop("The specified list of probabilities is null")
            }
            if (length(probabilities) == 0) {
                stop("The specified list of probabilities is empty")
            }
            
            message("Init ranges via probabilities ", .listToString(probabilities))
            
            sum = 0
            for (d in probabilities) {
                if (!is.numeric(d)) {
                    stop("One value inside the specified list ",
                        "of probabilities is not numeric")
                }
                
                sum <- sum + d
            }
    
            eps <- 1.0 - sum
            if (eps != 0 && abs(eps) > 0.000000000000009) {
                stop("The sum of the specified probabilities is ", sum, ", ",
                    "but has to be 1.0")
            }
            
            ranges <<- list()
            
            if (length(probabilities) == 1) {
                treatmentArmId = names(probabilities)[1]
                ranges[[treatmentArmId]] <<- RandomMethodRange(
                    treatmentArmId = treatmentArmId, 
                    lowerBound = 0.0, 
                    upperBound = 1.0)
            } else if (length(probabilities) > 1) {	
                treatmentArmIds <- names(probabilities)
                
                intersectionIndex <- round(length(probabilities) / 2)
                if (probabilities[[treatmentArmIds[intersectionIndex]]] == 0.0) {
                    for (i in 1:length(treatmentArmIds)) {
                        if (probabilities[[treatmentArmIds[intersectionIndex]]] != 0.0) {
                            intersectionIndex = i
                            break
                        }
                    }
                }
                
                from <- 0.0
                to <- 0.0
                for (i in 1:length(intersectionIndex)) {
                    treatmentArmId <- treatmentArmIds[i]
                    to <- to + probabilities[[treatmentArmId]]
                    ranges[[treatmentArmId]] <<- 
                        RandomMethodRange(
                            treatmentArmId = treatmentArmId, 
                            lowerBound = from, 
                            upperBound = to)
                    from <- to
                }
                
                intersectionFromValue <- to
                
                from <- 1.0
                to <- 1.0
                if (length(treatmentArmIds) > length(intersectionIndex)) {
                    for (i in length(treatmentArmIds):(length(intersectionIndex) + 1)) {
                        treatmentArmId <- treatmentArmIds[i]
                        from <- from - probabilities[[treatmentArmId]]
                        if (i == intersectionIndex) {
                            from <- intersectionFromValue
                        }
                        ranges[[treatmentArmId]] <<- 
                            RandomMethodRange(
                                treatmentArmId = treatmentArmId, 
                                lowerBound = from, 
                                upperBound = to)
                        to <- from
                    }
                }
            }
        },
        
        validate = function() {
            d <- 0
            sum <- 0
            randomMethodRanges <- list()
            # TODO sort randomMethodRanges
    
            for (range in randomMethodRanges) {
                sum <- sum + range$getUpperBound() - range$getLowerBound()
                if (range$getLowerBound() != d) {
                    stop("The lower border of range ", range, " ",
                        "does not agree to the upper border of the range before")
                }
                
                d <- range$getUpperBound()
            }
            
            if (sum != 1.0) {
                stop("The sum of the calculated probability ranges is ", sum, ", ",
                    "but has to be 1.0")
            }
        }
        
    )
)


