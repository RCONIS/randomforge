#'
#' Assert That an R Package Is Installed
#'
#' @description
#' Checks if the specified R package is installed and available.
#' If not, throws an error with instructions to install the package.
#'
#' @param packageName Character string specifying the name of the package to check.
#'
#' @return Invisibly returns \code{NULL}. Throws an error if the package is not installed.
#'
#' @keywords internal
#'
#' @noRd
#'
.assertPackageIsInstalled <- function(packageName) {
    if (!requireNamespace(packageName, quietly = TRUE)) {
        stop("Package \"", packageName, "\" is needed for this function to work. ",
            "Please install using, e.g., install.packages(\"", packageName, "\")",
            call. = FALSE
        )
    }
}

#'
#' Warn About Unknown Arguments Passed to a Function
#'
#' @description
#' Checks for unknown or unexpected arguments passed via \code{...} to a function.
#' Issues a warning for each argument not in the ignore list or not matching allowed unnamed parameters.
#'
#' @param ... Arguments passed to the target function.
#' @param functionName Character string specifying the name of the function being checked.
#' @param ignore Character vector of argument names to ignore.
#' @param numberOfAllowedUnnamedParameters Integer specifying the number of allowed unnamed parameters. Default is \code{0}.
#'
#' @return Invisibly returns \code{NULL}. Issues warnings for unknown arguments.
#'
#' @keywords internal
#'
#' @noRd
#'
.warnInCaseOfUnknownArguments <- function(
        ..., 
        functionName, 
        ignore = c(),
        numberOfAllowedUnnamedParameters = 0
        ) {
    args <- list(...)
    if (length(args) == 0) {
        return(invisible())
    }

    if (numberOfAllowedUnnamedParameters > 0) {
        ignore <- c(ignore, paste0("%param", 1:numberOfAllowedUnnamedParameters, "%"))
    }
    ignore <- c(ignore, "showWarnings")
    argNames <- names(args)
    for (i in 1:length(args)) {
        arg <- args[[i]]
        argName <- ifelse(is.null(argNames[i]) || argNames[i] == "",
            ifelse(inherits(arg, "StageResults"), "stageResultsName", paste0("%param", i, "%")),
            argNames[i]
        )
        if (!(argName %in% ignore) && !grepl("^\\.", argName)) {
            if (isS4(arg) || is.environment(arg)) {
                arg <- class(arg)
            }
            if (is.function(arg)) {
                arg <- "function(...)"
            }
            argValue <- paste0(" (", class(arg), ")")
            tryCatch(expr = {
                argValue <- .arrayToString(arg, vectorLookAndFeelEnabled = length(arg) > 1, encapsulate = is.character(arg))
                argValue <- paste0(" = ", argValue)
            }, error = function(e) {})
            warning("Argument unknown in ", functionName, "(...): '", argName, "'",
                argValue, " will be ignored",
                call. = FALSE
            )
        }
    }
}

#'
#' Assert That an Argument Is a Numeric Vector
#'
#' @description
#' Checks if the provided argument is a valid numeric vector.
#' Throws an error if the argument is missing, `NULL`, empty, contains
#' non-numeric values, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed.
#'        Default is `FALSE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if no
#'        default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#'
#' @noRd
#'
.assertIsNumericVector <- function(x, argumentName, naAllowed = FALSE, noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "'", argumentName,
            "' must be a valid numeric value or vector"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if ((!naAllowed && any(is.na(x))) || !is.numeric(x)) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " (",
            .arrayToString(x), ") must be a valid numeric value or vector"
        )
    }
}

#'
#' Assert That an Argument Is an Integer Vector
#'
#' @description
#' Checks if the provided argument is a valid integer vector.
#' Throws an error if the argument is missing, `NULL`, empty, contains
#' non-integer values, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed.
#'        Default is `FALSE`.
#' @param validateType Logical; if `TRUE`, checks that the vector is of integer
#'        type. Default is `TRUE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if no default
#'        value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#'
#' @noRd
#'
.assertIsIntegerVector <- function(
        x, 
        argumentName, 
        naAllowed = FALSE,
        validateType = TRUE, 
        noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "'", argumentName,
            "' must be a valid integer value or vector"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if (naAllowed && all(is.na(x))) {
        return(invisible())
    }

    if (!is.numeric(x) || (!naAllowed && any(is.na(x))) || (validateType && !is.integer(x)) ||
            (!validateType && any(as.integer(na.omit(x)) != na.omit(x)))) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " (",
            .arrayToString(x), ") must be a valid integer value or vector"
        )
    }
}

#'
#' Assert That an Argument Is a Logical Vector
#'
#' @description
#' Checks if the provided argument is a valid logical vector. 
#' Throws an error if the argument is missing, `NULL`, empty, contains 
#' non-logical values, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if no default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsLogicalVector <- function(x, argumentName, naAllowed = FALSE, noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "", sQuote(argumentName),
            " must be a valid logical value or vector"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if ((!naAllowed && all(is.na(x))) || !is.logical(x)) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName),
            " (", x, ") must be a valid logical value or vector"
        )
    }
}

#'
#' Assert That an Argument Has No Default Value
#'
#' @description
#' Checks if an argument is missing or has no default value available. 
#' Throws an error if the argument must be specified and is missing or `NA` (depending on `checkNA`).
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if no default value is available.
#' @param checkNA Logical; if `TRUE`, checks for `NA` values. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsNoDefault <- function(x, argumentName, noDefaultAvailable, checkNA = FALSE) {
    if (noDefaultAvailable && (!checkNA || all(is.na(x)))) {
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "", sQuote(argumentName),
            " must be specified, there is no default value"
        )
    }
}

#'
#' Assert That an Argument Is a Single Logical Value
#'
#' @description
#' Checks if the provided argument is a valid single logical value. 
#' Throws an error if the argument is missing, `NULL`, not of length one, 
#' not logical, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error 
#'        if no default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsSingleLogical <- function(x, argumentName, naAllowed = FALSE, noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "", sQuote(argumentName),
            " must be a single logical value"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if (length(x) > 1) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " ",
            .arrayToString(x, vectorLookAndFeelEnabled = TRUE),
            " must be a single logical value"
        )
    }

    if ((!naAllowed && is.na(x)) || !is.logical(x)) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " (",
            ifelse(isS4(x), class(x), x), ") must be a single logical value"
        )
    }
}

#'
#' Assert That an Argument Is a Single Numeric Value
#'
#' @description
#' Checks if the provided argument is a valid single numeric value. 
#' Throws an error if the argument is missing, `NULL`, not of length 
#' one, not numeric, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if 
#'        no default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsSingleNumber <- function(x, argumentName, naAllowed = FALSE, noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "", sQuote(argumentName),
            " must be a valid numeric value"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if (length(x) > 1) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " ",
            .arrayToString(x, vectorLookAndFeelEnabled = TRUE),
            " must be a single numeric value"
        )
    }

    if ((!naAllowed && is.na(x)) || !is.numeric(x)) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " (",
            ifelse(isS4(x), class(x), x),
            ") must be a valid numeric value"
        )
    }
}

#'
#' Assert That an Argument Is a Single Integer Value
#'
#' @description
#' Checks if the provided argument is a valid single integer value. 
#' Throws an error if the argument is missing, `NULL`, not of length 
#' one, not integer, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param validateType Logical; if `TRUE`, checks that the value is of integer type. 
#'        Default is `TRUE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if 
#'        no default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsSingleInteger <- function(
        x, argumentName, naAllowed = FALSE,
        validateType = TRUE, noDefaultAvailable = FALSE
        ) {
    .assertIsSinglePositiveInteger(
        x = x, argumentName = argumentName,
        naAllowed = naAllowed, validateType = validateType,
        mustBePositive = FALSE, noDefaultAvailable = noDefaultAvailable
    )
}

#'
#' Assert That an Argument Is a Single Positive Integer Value
#'
#' @description
#' Checks if the provided argument is a valid single positive integer value. 
#' Throws an error if the argument is missing, `NULL`, not of length one, 
#' not integer, not positive, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param ... Additional arguments (not used).
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param validateType Logical; if `TRUE`, checks that the value is of integer type. 
#'        Default is `TRUE`.
#' @param mustBePositive Logical; if `TRUE`, checks that the value is positive. 
#'        Default is `TRUE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if no default 
#'        value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsSinglePositiveInteger <- function(
        x, 
        argumentName, 
        ...,
        naAllowed = FALSE, 
        validateType = TRUE, 
        mustBePositive = TRUE, 
        noDefaultAvailable = FALSE
        ) {
    prefix <- ifelse(mustBePositive, "single positive ", "single ")
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT,
            "", sQuote(argumentName), " must be a ", prefix, "integer value"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if (length(x) > 1) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " ",
            .arrayToString(x, vectorLookAndFeelEnabled = TRUE),
            " must be a ", prefix, "integer value"
        )
    }

    if (!is.numeric(x) || (!naAllowed && is.na(x)) || (validateType && !is.integer(x)) ||
            (!validateType && !is.na(x) && !is.infinite(x) && as.integer(x) != x)) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "", sQuote(argumentName), " (", ifelse(isS4(x), class(x), x),
            ") must be a ", prefix, "integer value"
        )
    }

    if (mustBePositive && !is.na(x) && !is.infinite(x) && x <= 0) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "", sQuote(argumentName), " (", ifelse(isS4(x), class(x), x),
            ") must be a ", prefix, "integer value"
        )
    }
}

#'
#' Assert That an Argument Is a Single Character Value
#'
#' @description
#' Checks if the provided argument is a valid single character value. 
#' Throws an error if the argument is missing, `NULL`, not of length 
#' one, not character, or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#' @param noDefaultAvailable Logical; if `TRUE`, throws an error if 
#'        no default value is available. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsSingleCharacter <- function(x, argumentName, naAllowed = FALSE, noDefaultAvailable = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = FALSE)
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT, "", sQuote(argumentName),
            " must be a valid character value"
        )
    }

    .assertIsNoDefault(x, argumentName, noDefaultAvailable, checkNA = TRUE)

    if (length(x) > 1) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT, "", sQuote(argumentName), " ",
            .arrayToString(x, vectorLookAndFeelEnabled = TRUE),
            " must be a single character value"
        )
    }

    if (!is.character(x)) {
        stop(sprintf(paste0(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "'%s' must be a valid character value ",
            "(is an instance of class '%s')"
        ), argumentName, class(x)))
    }

    if (!naAllowed && is.na(x)) {
        stop(sprintf(paste0(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "'%s' (NA) must be a valid character value"
        ), argumentName))
    }
}


#'
#' Assert That an Argument Is a Character Vector
#'
#' @description
#' Checks if the provided argument is a valid character vector. 
#' Throws an error if the argument is missing, `NULL`, not character, 
#' or contains `NA` values when not allowed.
#'
#' @param x The object to check.
#' @param argumentName Character string specifying the name of the argument.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsCharacter <- function(x, argumentName, naAllowed = FALSE) {
    if (missing(x) || is.null(x) || length(x) == 0) {
        stop(
            C_EXCEPTION_TYPE_MISSING_ARGUMENT,
            "", sQuote(argumentName), " must be a valid character value or vector"
        )
    }

    if (!all(is.character(x))) {
        stop(sprintf(paste0(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "'%s' must be a valid character value or vector ",
            "(is an instance of class '%s')"
        ), argumentName, class(x)))
    }

    if (!naAllowed && any(is.na(x))) {
        stop(sprintf(
            paste0(
                C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
                "'%s' (%s) must be a valid character value (NA is not allowed)"
            ),
            argumentName, .arrayToString(x)
        ))
    }
}

#'
#' Assert That Values Are Within a Closed Interval
#'
#' @description
#' Checks if the provided values are within the specified closed interval \[lower, upper\].
#' Throws an error if any value is outside the interval or if `NA` values are not allowed.
#'
#' @param x Numeric vector to check.
#' @param xName Character string specifying the name of the argument.
#' @param ... Additional arguments (not used).
#' @param lower Numeric value specifying the lower bound of the interval.
#' @param upper Numeric value specifying the upper bound of the interval.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsInClosedInterval <- function(x, xName, ..., lower, upper, naAllowed = FALSE) {
    .warnInCaseOfUnknownArguments(functionName = ".assertIsInClosedInterval", ...)
    if (naAllowed && all(is.na(x))) {
        return(invisible())
    }

    if (!naAllowed && length(x) > 1 && any(is.na(x))) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "'", xName, "' (", .arrayToString(x), ") must be a valid numeric vector or a single NA"
        )
    }

    if (is.null(upper) || is.na(upper)) {
        if (any(x < lower, na.rm = TRUE)) {
            prefix <- ifelse(length(x) > 1, "each value of ", "")
            stop(
                C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS, prefix,
                "'", xName, "' (", .arrayToString(x), ") must be >= ", lower
            )
        }
    } else if (any(x < lower, na.rm = TRUE) || any(x > upper, na.rm = TRUE)) {
        stop(
            C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS,
            "'", xName, "' (", .arrayToString(x), ") is out of bounds [", lower, "; ", upper, "]"
        )
    }
}

#'
#' Assert That Values Are Within an Open Interval
#'
#' @description
#' Checks if the provided values are within the specified open interval (lower, upper).
#' Throws an error if any value is outside the interval or if `NA` values are not allowed.
#'
#' @param x Numeric vector to check.
#' @param xName Character string specifying the name of the argument.
#' @param lower Numeric value specifying the lower bound of the interval.
#' @param upper Numeric value specifying the upper bound of the interval.
#' @param naAllowed Logical; if `TRUE`, `NA` values are allowed. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. Throws an error if the check fails.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.assertIsInOpenInterval <- function(x, xName, lower, upper, naAllowed = FALSE) {
    if (naAllowed && all(is.na(x))) {
        return(invisible())
    }

    if (!naAllowed && length(x) > 1 && any(is.na(x))) {
        stop(
            C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT,
            "'", xName, "' (", .arrayToString(x), ") must be a valid numeric vector or a single NA"
        )
    }

    if (is.null(upper) || is.na(upper)) {
        if (any(x <= lower, na.rm = TRUE)) {
            prefix <- ifelse(length(x) > 1, "each value of ", "")
            stop(
                C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS, prefix,
                "'", xName, "' (", .arrayToString(x), ") must be > ", lower
            )
        }
    } else if (any(x <= lower, na.rm = TRUE) || any(x >= upper, na.rm = TRUE)) {
        stop(
            C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS,
            "'", xName, "' (", .arrayToString(x), ") is out of bounds (", lower, "; ", upper, ")"
        )
    }
}
