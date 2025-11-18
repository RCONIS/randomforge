#'
#' Constants for Exception Types, Identifiers, and Separators
#'
#' @description
#' Defines string constants used for exception messages, 
#' unique identifiers, and separators within the randomization system.
#'
#' @section Exception Type Constants:
#' \describe{
#'   \item{C_EXCEPTION_TYPE_RUNTIME_ISSUE}{Indicates a runtime exception.}
#'   \item{C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT}{Indicates an illegal argument.}
#'   \item{C_EXCEPTION_TYPE_ILLEGAL_DATA_INPUT}{Indicates illegal data input.}
#'   \item{C_EXCEPTION_TYPE_CONFLICTING_ARGUMENTS}{Indicates conflicting arguments.}
#'   \item{C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS}{Indicates an argument is out of bounds.}
#'   \item{C_EXCEPTION_TYPE_ARGUMENT_LENGTH_OUT_OF_BOUNDS}{Indicates argument length is out of bounds.}
#'   \item{C_EXCEPTION_TYPE_INDEX_OUT_OF_BOUNDS}{Indicates an index is out of bounds.}
#'   \item{C_EXCEPTION_TYPE_MISSING_ARGUMENT}{Indicates a missing argument.}
#'   \item{C_EXCEPTION_TYPE_INCOMPLETE_ARGUMENTS}{Indicates incomplete associated arguments.}
#' }
#'
#' @section Other Constants:
#' \describe{
#'   \item{GENERAL_UNIQUE_ID_BUILDER}{Instance of `GeneralUniqueIdBuilder` for generating unique IDs.}
#'   \item{NO_FACTOR_ID}{String representing the absence of a factor ID.}
#'   \item{FACTOR_SEPARATOR}{Separator string for factors.}
#'   \item{FACTOR_LEVEL_SEPARATOR}{Separator string for factor levels.}
#'   \item{RANDOMIZED}{String indicating randomized status.}
#' }
#' 
#' @include class_general_unique_id_builder.R
#'
#' @keywords internal
#' 
#' @noRd
#' 
NULL

C_EXCEPTION_TYPE_RUNTIME_ISSUE = "Runtime exception: "
C_EXCEPTION_TYPE_ILLEGAL_ARGUMENT = "Illegal argument: "
C_EXCEPTION_TYPE_ILLEGAL_DATA_INPUT = "Illegal data input: "
C_EXCEPTION_TYPE_CONFLICTING_ARGUMENTS = "Conflicting arguments: "
C_EXCEPTION_TYPE_ARGUMENT_OUT_OF_BOUNDS = "Argument out of bounds: "
C_EXCEPTION_TYPE_ARGUMENT_LENGTH_OUT_OF_BOUNDS = "Argument length out of bounds: "
C_EXCEPTION_TYPE_INDEX_OUT_OF_BOUNDS = "Index out of bounds: "
C_EXCEPTION_TYPE_MISSING_ARGUMENT = "Missing argument: "
C_EXCEPTION_TYPE_INCOMPLETE_ARGUMENTS = "Incomplete associated arguments: "

GENERAL_UNIQUE_ID_BUILDER <- GeneralUniqueIdBuilder$new()

NO_FACTOR_ID <- "NO_FACTOR_ID"
FACTOR_SEPARATOR <- "#SEP#"
FACTOR_LEVEL_SEPARATOR <- "#LEVSEP#"	

RANDOMIZED <- "RANDOMIZED"

