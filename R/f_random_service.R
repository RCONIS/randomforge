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
#' Generate and Persist the Next Randomization Result
#'
#' @description
#' Retrieves the next random allocation value, generates a new randomization 
#' result using the specified method, updates the system state, and persists 
#' all relevant objects in the database.
#'
#' @param randomDataBase Object providing access to randomization data and persistence methods.
#' @param randomProject `RandomProject` reference class object representing the current project.
#' @param randomMethod Object implementing the randomization method with a `randomize` function.
#' @param randomAllocationValueService Service object for managing random allocation values.
#'
#' @return A `RandomResult` reference class object representing the outcome of the randomization.
#'
#' @details
#' Validates the project, retrieves configuration and allocation values, 
#' manages system state, and persists the result and subject information.
#'
#' @export
#' 
getNextRandomResult <- function(
        randomDataBase, 
        randomProject, 
        randomMethod, 
        randomAllocationValueService) {
        
    randomDataBase$validateRandomProject(randomProject)
        
    randomConfiguration <- randomDataBase$getLastRandomConfiguration(randomProject)
    if (is.null(randomConfiguration)) {
        stop("No random configuration found for project ", sQuote(randomProject$toString()))
    }
    
    randomAllocationValue <- randomAllocationValueService$getNextRandomAllocationValue(randomConfiguration)
    if (is.null(randomAllocationValue)) {
        randomAllocationValueService$createNewRandomAllocationValues(randomConfiguration)
        randomAllocationValue <- randomAllocationValueService$getNextRandomAllocationValue(randomConfiguration)
    }
    
    message("Get next random result (", randomAllocationValue$toString(), ")...")
    
    # get previous random system state
    randomSystemState <- NULL 
    lastSubject <- randomDataBase$getLastSubject(randomProject)
    if (!is.null(lastSubject)) {
        if (is.null(lastSubject$randomResult)) {
            stop("'randomResult' of subject ", lastSubject$toString(), " does not exist")
        }
        randomSystemState <- lastSubject$randomResult$randomSystemState$clone()
    } else {
        randomSystemState <- RandomSystemState()
        randomSystemState$init(randomConfiguration$treatmentArmIds, 
            factorIds = randomConfiguration$factorIds, 
            strataIds = NULL # TODO implement strataIds
        )
    }
    if (is.null(randomSystemState)) {
        stop("Failed to get random system state")
    }

    factorLevels <- list() # TODO implement factorLevels
    
    randomResult <- randomMethod$randomize(factorLevels, randomSystemState, randomAllocationValue)
    randomDataBase$persist(randomResult)
    
    message("Random result: ", randomResult$toString())
    
    randomAllocationValue$randomResult <- randomResult
    randomDataBase$persist(randomAllocationValue)
    
    randomNumber <- randomDataBase$createNewSubjectRandomNumber(randomProject)
    
    randomSubject <- RandomSubject(
        randomProject = randomProject, 
        randomNumber = randomNumber, 
        factorLevels = factorLevels, 
        randomResult = randomResult)
    randomSubject$setStatus(RANDOMIZED);
    
    randomDataBase$persist(randomSubject)
    
    return(randomResult)
}



