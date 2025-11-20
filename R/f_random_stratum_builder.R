
#'
#' Create Stratum Identifier from Factor Levels
#'
#' @description
#' Generates a unique stratum identifier string by concatenating factor names and their levels, separated by predefined delimiters. Validates input to ensure names and levels do not contain forbidden separator strings.
#'
#' @param factorLevels Named list of factor levels to include in the stratum identifier.
#'
#' @return A character string representing the stratum identifier, or \code{NO_FACTOR_ID} if \code{factorLevels} is \code{NULL} or empty.
#'
#' @keywords internal
#' 
#' @noRd
#' 
createStratumId <- function(factorLevels) {
    if (is.null(factorLevels) || length(factorLevels) == 0) {
        return(NO_FACTOR_ID)
    }

    sb <- StringBuilder()

    counter <- 1
    for (factorName in names(factorLevels)) {
        if (is.null(factorName) || nchar(trimws(factorName)) == 0) {
            stop("The specified factor name (#", counter, ") is invalid")
        }

        if (grepl(FACTOR_LEVEL_SEPARATOR, factorName) || grepl(FACTOR_SEPARATOR, factorName)) {
            stop(
                "The specified factor name '", factorName, "' is invalid ",
                "because it contains a forbidden string ('", FACTOR_LEVEL_SEPARATOR, "' ",
                "and '", FACTOR_SEPARATOR, "' are not allowed)"
            )
        }

        factorLevel <- factorLevels.get(factorName)
        if (is.null(factorLevel) || nchar(trimws(factorLevel)) == 0) {
            stop("The specified factor level (#", counter, ") is invalid")
        }

        if (grepl(FACTOR_LEVEL_SEPARATOR, factorLevel) || grepl(FACTOR_SEPARATOR, factorLevel)) {
            stop(
                "The specified factor level '", factorName, "' is invalid ",
                "because it contains a forbidden string ('", FACTOR_LEVEL_SEPARATOR, "' ",
                "and '", FACTOR_SEPARATOR, "' are not allowed)"
            )
        }

        if (sb$length() > 0) {
            sb$append(FACTOR_SEPARATOR)
        }

        sb$append(factorName, FACTOR_LEVEL_SEPARATOR, factorLevel)

        counter <- counter + 1
    }

    return(sb$toString())
}
