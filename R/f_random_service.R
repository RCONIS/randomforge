
#' @export 
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
    
    randomAllocationValueBufferMinimumSize <- randomConfiguration$ravBufferMinimumSize
    randomAllocationValueBufferMaximumSize <- randomConfiguration$ravBufferMaximumSize
    
    randomAllocationValue <- randomAllocationValueService$getNextRandomAllocationValue(randomConfiguration)
    if (is.null(randomAllocationValue)) {
        randomAllocationValueService$createNewRandomAllocationValues(
            randomConfiguration, randomAllocationValueBufferMaximumSize)
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



