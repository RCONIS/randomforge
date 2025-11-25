# ------------------------------------------------------------------------------
#  randomforge — Innovating the Future of Randomization
#  Framework for transparent and extensible clinical trial randomization in R
#
#  Author: Friedrich Pahlke, RPACT GmbH
#  Copyright (c) 2025
#
#  This file is part of the randomforge R package.
#  The package is licensed under the GNU Lesser General Public License (LGPL-3.0).
#  Full license text: https://www.gnu.org/licenses/lgpl-3.0.txt
#
#  Source code and issue tracker:
#  https://github.com/RCONIS/randomforge
#
#  Documentation:
#  https://randomforge.org
#
#  For collaboration or contributions:
#  friedrich.pahlke@rpact.com
#  info@randomforge.org
# ------------------------------------------------------------------------------

#' @include f_constants.R
NULL

.getPackageVersionString <- function() {
    return(paste(unlist(utils::packageVersion("rpact")), collapse = "."))
}

#'
#' Convert Treatment List to Data Frame
#'
#' @description
#' Converts a named list of treatment arm values into a data frame, 
#' with each list element becoming a column. Handles S4 objects 
#' and concatenates values if necessary.
#'
#' @param x A named list where each element represents a treatment arm value.
#' @param colNamePrefix Character string to prefix column names. Default is \code{""}.
#'
#' @return A data frame with columns corresponding to treatment arm IDs.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.treatmentListToDataFrame <- function(x, colNamePrefix = "") {
    df <- NULL
    for (treatmentArmId in names(x)) {
        value <- x[[treatmentArmId]]
        if (isS4(value)) {
            value <- value$toString()
        }
        if (length(value) > 1) {
            value <- paste0(value, collapse = ", ")
        }
        entry <- data.frame(value)
        names(entry) <- paste0(colNamePrefix, treatmentArmId)
        if (is.null(df)) {
            df <- entry
        } else {
            df <- cbind(df, entry)
        }
    }
    return(df)
}

#'
#' Concatenate Values with Custom Separator and Mode
#'
#' @description
#' Concatenates elements of a vector into a single string using a specified 
#' separator and mode. Supports CSV, vector, and logical 
#' conjunction/disjunction formats.
#'
#' @param x A vector of values to concatenate.
#' @param separator Character string used to separate values. 
#'        Default is \code{", "} .
#' @param mode Character; determines the concatenation style. 
#'        Options are \code{"csv"}, \code{"vector"}, \code{"and"}, or \code{"or"}.
#'
#' @return A concatenated character string representing the input values.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.getConcatenatedValues <- function(x, separator = ", ", mode = c("csv", "vector", "and", "or")) {
    if (is.null(x) || length(x) <= 1) {
        return(x)
    }

    mode <- match.arg(mode)
    if (mode %in% c("csv", "vector")) {
        result <- paste(x, collapse = separator)
        if (mode == "vector") {
            result <- paste0("c(", result, ")")
        }
        return(result)
    }

    if (length(x) == 2) {
        return(paste(x, collapse = paste0(" ", mode, " ")))
    }

    space <- ifelse(grepl(" $", separator), "", " ")
    part1 <- x[1:length(x) - 1]
    part2 <- x[length(x)]
    return(paste0(paste(part1, collapse = separator), separator, space, mode, " ", part2))
}

#'
#' Convert Array to String Representation
#'
#' @description
#' Converts an array, vector, or matrix to a string representation with 
#' customizable formatting options. Handles numeric rounding, encapsulation, 
#' truncation, and different output modes (CSV, vector, logical 
#' conjunction/disjunction).
#'
#' @param x The array, vector, or matrix to convert.
#' @param ... Additional arguments (currently not used).
#' @param separator Character string used to separate values. 
#'        Default is \code{", "} .
#' @param vectorLookAndFeelEnabled Logical; if \code{TRUE}, formats output 
#'        as R vector. Default is \code{FALSE}.
#' @param encapsulate Logical; if \code{TRUE}, encapsulates values in single 
#'        quotes. Default is \code{FALSE}.
#' @param digits Integer; number of digits to round numeric values. 
#'        Default is \code{3}.
#' @param maxLength Integer; maximum number of elements to display before 
#'        truncating. Default is \code{80L}.
#' @param maxCharacters Integer; maximum number of characters in output string 
#'        before truncating. Default is \code{160L}.
#' @param mode Character; output style: \code{"csv"}, \code{"vector"}, 
#'        \code{"and"}, or \code{"or"}.
#'
#' @return A character string representing the input array.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.arrayToString <- function(x, ..., separator = ", ",
        vectorLookAndFeelEnabled = FALSE,
        encapsulate = FALSE,
        digits = 3,
        maxLength = 80L,
        maxCharacters = 160L,
        mode = c("csv", "vector", "and", "or")) {
    if (!is.na(digits) && digits < 0) {
        stop(C_EXCEPTION_TYPE_RUNTIME_ISSUE, "'digits' (", digits, ") must be >= 0")
    }

    .assertIsSingleInteger(maxLength, "maxLength", naAllowed = FALSE, validateType = FALSE)
    .assertIsInClosedInterval(maxLength, "maxLength", lower = 1, upper = NULL)
    .assertIsSingleInteger(maxCharacters, "maxCharacters", naAllowed = FALSE, validateType = FALSE)
    .assertIsInClosedInterval(maxCharacters, "maxCharacters", lower = 3, upper = NULL)

    if (missing(x) || is.null(x) || length(x) == 0) {
        return("NULL")
    }

    if (length(x) == 1 && is.na(x)) {
        return("NA")
    }

    if (!is.numeric(x) && !is.character(x) && !is.logical(x) && !is.integer(x)) {
        return(class(x))
    }

    if (is.numeric(x) && !is.na(digits)) {
        if (digits > 0) {
            indices <- which(!is.na(x) & abs(x) >= 10^-digits)
        } else {
            indices <- which(!is.na(x))
        }
        x[indices] <- as.character(round(x[indices], digits))
    }

    mode <- match.arg(mode)
    if (mode == "csv" && vectorLookAndFeelEnabled) {
        mode <- "vector"
    }

    if (is.matrix(x) && nrow(x) > 1 && ncol(x) > 1) {
        result <- c()
        for (i in 1:nrow(x)) {
            row <- x[i, ]
            if (encapsulate) {
                row <- paste0("'", row, "'")
            }
            result <- c(result, paste0("(", paste(row, collapse = separator), ")"))
        }
        return(.getConcatenatedValues(result, separator = separator, mode = mode))
    }

    if (encapsulate) {
        x <- paste0("'", x, "'")
    }

    if (length(x) > maxLength) {
        x <- c(x[1:maxLength], "...")
    }

    s <- .getConcatenatedValues(x, separator = separator, mode = mode)
    if (nchar(s) > maxCharacters && length(x) > 1) {
        s <- x[1]
        index <- 2
        while (nchar(paste0(s, separator, x[index])) <= maxCharacters && index <= length(x)) {
            s <- paste0(s, separator, x[index])
            index <- index + 1
        }
        s <- paste0(s, separator, "...")
        if (vectorLookAndFeelEnabled && length(x) > 1) {
            s <- paste0("c(", s, ")")
        }
    }

    return(s)
}

#'
#' Convert List to String Representation
#'
#' @description
#' Converts a (possibly nested) named list to a string representation, with 
#' options for encapsulation and R list formatting. Handles nested lists and 
#' arrays, and supports custom separators.
#'
#' @param a A named list to convert.
#' @param separator Character string used to separate entries. 
#'        Default is \code{", "} .
#' @param listLookAndFeelEnabled Logical; if \code{TRUE}, formats output as 
#'        R list. Default is \code{FALSE}.
#' @param encapsulate Logical; if \code{TRUE}, encapsulates values in single 
#'        quotes. Default is \code{FALSE}.
#'
#' @return A character string representing the input list.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.listToString <- function(a, separator = ", ", listLookAndFeelEnabled = FALSE, encapsulate = FALSE) {
    if (missing(a) || is.null(a) || length(a) == 0) {
        return("NULL")
    }

    if (length(a) == 1 && is.na(a)) {
        return("NA")
    }

    result <- ""
    for (name in names(a)) {
        value <- a[[name]]

        if (is.list(value)) {
            value <- .listToString(value,
                separator = separator,
                listLookAndFeelEnabled = listLookAndFeelEnabled,
                encapsulate = encapsulate
            )
            if (!listLookAndFeelEnabled) {
                value <- paste0("{", value, "}")
            }
        } else {
            if (length(value) > 1) {
                value <- .arrayToString(value,
                    separator = separator,
                    encapsulate = encapsulate
                )
                value <- paste0("(", value, ")")
            } else if (encapsulate) {
                value <- sQuote(value)
            }
        }

        entry <- paste(name, "=", value)

        if (nchar(result) > 0) {
            result <- paste(result, entry, sep = ", ")
        } else {
            result <- entry
        }
    }

    if (!listLookAndFeelEnabled) {
        return(result)
    }

    return(paste0("list(", result, ")"))
}

#'
#' Set Random Seed with Error Handling
#'
#' @description
#' Sets the random seed for reproducibility using the Mersenne-Twister 
#' algorithm and Inversion for normal generation. Handles errors gracefully 
#' and returns the seed invisibly.
#'
#' @param seed Integer or numeric value to set as the random seed.
#'
#' @return The seed value (invisibly). If an error occurs, returns \code{NA_real_}.
#'
#' @keywords internal
#' 
#' @noRd
#' 
.setSeed <- function(seed) {
    tryCatch(
        {
            set.seed(seed, kind = "Mersenne-Twister", normal.kind = "Inversion")
        },
        error = function(e) {
            # .logError("Failed to set seed to '%s' (%s): %s", seed, class(seed), e)
            seed <- NA_real_
            traceback()
        }
    )

    invisible(seed)
}

#'
#' Generate Named List of Treatment Arm Values
#'
#' @description
#' Creates a named list of treatment arm values from variable arguments, 
#' ensuring the correct number of values per treatment arm. Handles block 
#' size logic for balanced randomization.
#'
#' @param ... Values or block size for treatment arms.
#' @param treatmentArmIds Character vector of treatment arm identifiers.
#'
#' @return A named list of treatment arm values.
#'
#' @export
#' 
getTreatmentArmValueList <- function(..., treatmentArmIds) {
    args <- list(...)
    n <- length(treatmentArmIds)
    if (length(args) == 1) {
        blockSize <- args[[1]]
        if (blockSize %% n != 0) {
            stop("The number of treatments ", n, " is not a multiple of block length ", blockSize)
        }

        args[[1]] <- blockSize / n
        args <- rep(args, n)
    }
    if (length(args) != n) {
        stop("Illegal number of treatment arm values")
    }
    names(args) <- treatmentArmIds
    return(args)
}

#'
#' Write Data Frames to Excel File
#'
#' @description
#' Writes a named list of data frames to an Excel file, with optional 
#' meta information. Each list element becomes a separate sheet in the output file.
#'
#' @param sheetList A named list of data frames; each name represents the sheet name.
#' @param file Character string specifying the output Excel file path.
#' @param ... Additional arguments (currently not used).
#' @param addMetaInformationSheet Logical; if \code{TRUE}, adds a meta information sheet. Default is \code{TRUE}.
#' @param userName Character string for the user name in meta information. Default is \code{"Anonymous"}.
#'
#' @return The file path of the written Excel file.
#'
#' @export 
#' 
writeExcelFile <- function(sheetList, file, ..., addMetaInformationSheet = TRUE, userName = "Anonymous") {
    tryCatch(
        {
            .assertPackageIsInstalled("writexl")
            
            if (length(sheetList) == 0 || !is.list(sheetList)) {
                stop("'sheetList' must be a valid list of data frames")
            }
            
            sheetNames <- names(sheetList)
            sheetNames <- sheetNames[sheetNames != ""]
            if (length(sheetList) > length(sheetNames)) {
                stop("'sheetList' must be a named list of data frames")
            }
            
            for (sheet in sheetList) {
                if (!is.data.frame(sheet)) {
                    stop("'sheetList' must be a named list of data frames")
                }
            }
            
            message("Write Excel file ", sQuote(file), " with ", length(sheetList), " sheets...")
            if (addMetaInformationSheet) {
                meta <- .getMetaInformation(userName)
                if (!is.null(meta)) {
                    sheetList[["Meta information"]] <- meta
                }
            }
            
            writexl::write_xlsx(sheetList, path = file, col_names = TRUE, format_headers = TRUE)
            
            message("Completed: write Excel file ", sQuote(file), " with ", length(sheetList), " sheets.")
        },
        error = function(e) {
            stop("Failed to write Excel file ", sQuote(file), ": ", e$message)
        }
    )
    return(file)
}

.getMetaInformation <- function(userName) {
    currentLocale <- Sys.getlocale("LC_TIME")
    tryCatch(
        {
            Sys.setlocale("LC_TIME", "en_US.UTF-8")
            meta <- data.frame(
                "Created by" = "randomforge",
                "Creation date" = format(Sys.time(), "%B %d, %Y"),
                "Creation time" = format(Sys.time(), "%X"),
                "User" = userName,
                "randomforge package version" = paste0("randomforge ", packageVersion("randomforge")),
                "The documentation is hosted at" = "https://www.randomforge.org",
                "randomforge is developed by" = "Friedrich Pahlke, www.linkedin.com/in/pahlke",
                stringsAsFactors = FALSE, 
                check.names = FALSE
            )
            meta <- data.frame(Parameter = names(meta), Value = unlist(meta, use.names = FALSE))
            return(meta)
        },
        error = function(e) {
            message("Failed to get meta information ", sQuote(file), ": ", e$message)
        }, finally = {
            Sys.setlocale("LC_TIME", currentLocale)
        }
    )
    return(NULL)
}
