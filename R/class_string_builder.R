
#'
#' StringBuilder Reference Class
#'
#' @description
#' Provides a mutable string builder for efficient string concatenation and manipulation.
#'
#' @field values Character vector storing the string fragments.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(values = character(0), ...)}{Creates a new `StringBuilder` instance.}
#'   \item{show()}{Prints the current string to the console.}
#'   \item{append(...)}{Appends one or more values to the string.}
#'   \item{length()}{Returns the number of fragments in the builder.}
#'   \item{isEmpty()}{Checks if the builder is empty.}
#'   \item{insert(index, x)}{Inserts a value at the specified index.}
#'   \item{toString()}{Returns the concatenated string.}
#' }
#'
#' @keywords internal
#' 
#' @noRd 
#' 
StringBuilder <- setRefClass("StringBuilder",
    fields = list(
        values = "character"
    ),
    methods = list(
        initialize = function(values = character(0), ...) {
            callSuper(values = values, ...)
        },
        show = function() {
            cat(toString(), "\n")
        },
        append = function(...) {
            args <- list(...)
            x <- paste0(args, collapse = "")
            .self$values <- c(.self$values, x)
        },
        length = function() {
            return(base::length(.self$values))
        },
        isEmpty = function() {
            return(base::length(.self$values) == 0)
        },
        insert = function(index, x) {
            if (base::length(.self$values) == 0) {
                .self$values <- x
                return(invisible())
            }
            if (index < 1 || index > base::length(.self$values)) {
                stop(C_EXCEPTION_TYPE_INDEX_OUT_OF_BOUNDS, 
                    "index ", index, " out of bounds [1; ", base::length(.self$values), "]")
            }
            if (index == 1) {
                .self$values <- c(x, .self$values)
            } else {
                .self$values <- c(.self$values[1:index], x, 
                    .self$values[(index + 1):base::length(.self$values)])
            }
        },
        toString = function() {
            return(paste0(.self$.self$values, collapse = ""))
        }
    )
)

