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
#' RandomMethodRangeSetPBR Reference Class
#'
#' @description
#' Extends `RandomMethodRangeSet` to support probability block randomization, initializing ranges based on a `RandomBlock` object.
#'
#' @field Inherits all fields from `RandomMethodRangeSet`.
#'
#' @section Methods:
#' \describe{
#'   \item{initialize(block, ...)}{Initializes a new `RandomMethodRangeSetPBR` instance using a `RandomBlock`. Validates the block and sets up ranges according to its probabilities.}
#' }
#'
#' @keywords internal
#' 
#' @include class_random_method_range_set.R
#' 
RandomMethodRangeSetPBR <- setRefClass("RandomMethodRangeSetPBR",
    contains = "RandomMethodRangeSet",
    methods = list(
        initialize = function(block, ...) {
            callSuper(...)
            if (!inherits(block, "RandomBlock")) {
                stop("'block' must be an instance of class 'RandomBlock' (is ", class(block), ")")
            }
            
            if (block$isCompleted()) {
                stop("The specified block '", block$toString(), "' is completed")
            }
            
            initRanges(block$getProbabilities())
        }
    )
)