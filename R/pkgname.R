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

#'
#' @title
#' randomforge Package
#'
#' @description
#' Randomforge provides an extensible and transparent framework for 
#' implementing, evaluating, and applying randomization methods for 
#' clinical trials. 
#' 
#' @details
#' The package aims to support a broad range of classical, 
#' covariate-adaptive, and response-adaptive techniques while 
#' enabling reproducibility, auditability, and methodological clarity.
#' Built as part of the open **randomforge** initiative ("Innovating the 
#' Future of Randomization"), the package encourages community 
#' collaboration, modular extensions, and contributions from academia, 
#' industry, and clinical researchers.
#'  
#' The architecture is designed for integration into larger ecosystems, 
#' including Shiny applications, APIs, and cloud-based workflows.
#'
#' @docType package
#' @author Friedrich Pahlke
#' @name randomforge
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

