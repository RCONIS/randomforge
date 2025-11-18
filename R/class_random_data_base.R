
.showList <- function(x, title) {
    if (is.null(x) || length(x) == 0) {
        return(character(0))
    }
    sb <- StringBuilder()
    sb$append(title, ":\n")
    for (entry in x) {
        sb$append(entry$toString(prefix = "\t"), "\n")
    }
    return(sb$toString())
}

#' @export 
getRandomDataBase <- function() {
    return(RandomDataBase())
}

#'
#' @include f_constants.R
#' @include class_general_unique_id_builder.R
#' 
RandomDataBase <- setRefClass("RandomDataBase",
    fields = list(
        uniqueId = "character",
        creationDate = "POSIXct",
        randomProjects = "list",
        randomConfigurations = "list",
        randomAllocationValues = "list",
        randomSubjects = "list",
        randomResults = "list"
    ),
    methods = list(
        initialize = function(...,
                creationDate = Sys.time()) {
            callSuper(
                creationDate = creationDate,
                ...)
            uniqueId <<- GENERAL_UNIQUE_ID_BUILDER$getUniqueId()
            randomAllocationValues <<- list()
            randomConfigurations <<- list()
            randomSubjects <<- list()
            randomResults <<- list()
        },
        validateRandomProject = function(randomProject) {
            for (p in randomProjects) {
                if (p$uniqueId == randomProject$uniqueId) {
                    return(invisible())
                }
            }
            stop("'randomProjects' does not exist und must be persisted first")
        },
        show = function() {
            sb <- StringBuilder()
            sb$append(.self$toString(), "\n")
            sb$append(.showList(randomProjects, "Random projects"))
            sb$append(.showList(randomConfigurations, "Random configurations"))
            sb$append(.showList(randomAllocationValues, "Random allocation values"))
            sb$append(.showList(randomSubjects, "Random subjects"))
            cat(sb$toString())
            
            cat("Random system state:\n")
            for (randomResult in randomResults) {
                if (!is.null(randomResult) && !is.null(randomResult$randomSystemState)) {
                    randomResult$randomSystemState$show(prefix = "\t")
                }
            }
            cat("Random results:\n")
            for (randomResult in randomResults) {
                if (!is.null(randomResult) && !is.null(randomResult$randomSystemState)) {
                    randomResult$show(prefix = "\t")
                }
            }
        },
        toString = function() {
            sb <- StringBuilder()
            sb$append("Random data base: ")
            sb$append(uniqueId)
            sb$append(" [")
            sb$append("randomAllocationValues: ", length(randomAllocationValues), ", ")
            sb$append("randomConfigurations: ", length(randomConfigurations), ", ")
            sb$append("randomSubjects: ", length(randomSubjects))
            sb$append("]")
            return(sb$toString())
        },
        persist = function(obj) {
            if (inherits(obj, "RandomAllocationValue")) {
                randomAllocationValues[[length(randomAllocationValues) + 1]] <<- obj
            }
            else if (inherits(obj, "RandomConfiguration")) {
                randomConfigurations[[length(randomConfigurations) + 1]] <<- obj
            }
            else if (inherits(obj, "RandomSubject")) {
                randomSubjects[[length(randomSubjects) + 1]] <<- obj
            }
            else if (inherits(obj, "RandomResult")) {
                randomResults[[length(randomResults) + 1]] <<- obj
            }
            else if (inherits(obj, "RandomProject")) {
                randomProjects[[length(randomProjects) + 1]] <<- obj
            }
        },
        getRandomProjectUniqueIds = function(objects) {
            uniqueIds <- character(0)
            for (obj in objects) {
                uniqueIds <- c(uniqueIds, obj$randomProject$uniqueId)
            }
            return(uniqueIds)
        },
        getLastSubject = function(randomProject) {
            if (length(randomSubjects) == 0) {
                return(NULL)
            }
            
            s <- randomSubjects[getRandomProjectUniqueIds(randomSubjects) == randomProject$uniqueId]
            if (length(s) == 0) {
                return(NULL)
            }
            
            return(s[[length(s)]])
        },
        getLastRandomConfiguration = function(randomProject) {
            if (length(randomConfigurations) == 0) {
                return(NULL)
            }
            
            configs <- randomConfigurations[getRandomProjectUniqueIds(randomConfigurations) == randomProject$uniqueId]
            if (length(configs) == 0) {
                return(NULL)
            }
            
            return(configs[[length(configs)]])
        },
        createNewSubjectRandomNumber = function(randomProject) {
            if (length(randomSubjects) == 0) {
                return(1L)
            }
            
            randomNumber <- 1L
            for (randomSubject in randomSubjects) {
                if (randomSubject$randomProject$uniqueId == randomProject$uniqueId &&
                        randomSubject$randomNumber > randomNumber) {
                    randomNumber <- randomSubject$randomNumber
                }
            }
            return(randomNumber + 1L)
        }
    )
)

#' @export 
as.data.frame.RandomDataBase <- function(x, ...) {
    do.call(rbind.data.frame, lapply(x$randomSubjects, as.data.frame))
}
