
#'
#' @title
#'
#' @description
#'
#' @details
#'
#' @docType package
#' @author Friedrich Pahlke
#' @name rpact
#'
#' @import methods
#' @import stats
#' @import utils
#' @import tools
#' @importFrom rlang .data
#' @importFrom knitr kable
#' @importFrom knitr knit_print
#'
"_PACKAGE"
#> [1] "_PACKAGE"

.onLoad <- function(libname, pkgname) {
    base::assign("GENERAL_UNIQUE_ID_BUILDER", GeneralUniqueIdBuilder$new()) # , envir = parent.env(environment())
}

.onAttach <- function(libname, pkgname) {
    if (grepl("^\\d\\.\\d\\.\\d\\.\\d{4,4}$", .getPackageVersionString())) {
        packageStartupMessage(paste0("randomforge developer version ", 
            .getPackageVersionString(), " loaded"))
    } 
}

.onDetach <- function(libpath) {
}

.onUnload <- function(libpath) {
}

