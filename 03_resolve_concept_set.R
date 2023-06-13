filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))

outputFolder <- file.path(rootFolder,
                          "ConceptsResolved")
unlink(x = outputFolder,
       recursive = TRUE,
       force = TRUE)
dir.create(path = outputFolder,
           showWarnings = FALSE)

cohortIds <- c(cohortsToStudy$targetCohortIds,
               cohortsToStudy$featureCohortIds) |> unique()

cohortsToResolve <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = cohortIds) |> 
  dplyr::arrange(cohortId)

conceptSets <-
  ConceptSetDiagnostics::extractConceptSetsInCohortDefinitionSet(cohortDefinitionSet = cohortsToResolve)
saveRDS(object = conceptSets,
        file = file.path(outputFolder,
                         "conceptSets.RDS"))

#############

conceptSets <- readRDS(file = file.path(outputFolder,
                                        "conceptSets.RDS"))
uniqueConceptSets <- conceptSets |>
  dplyr::select(uniqueConceptSetId,
                conceptSetExpression)

#create connection
connectionDetails <-
  PrivateScripts::createConnectionDetails(cdmSources = cdmSources)
cdmSource <- PrivateScripts::getCdmSource(cdmSources = cdmSources)

# loop thru concept set and resolve them
resolvedConceptSet <- list()
for (i in (1:nrow(uniqueConceptSets))) {
  resolvedConceptSet[[i]] <-
    ConceptSetDiagnostics::resolveConceptSetExpression(
      conceptSetExpression = uniqueConceptSets[i, ]$conceptSetExpression |>
        RJSONIO::fromJSON(digits = 23),
      connectionDetails = connectionDetails,
      vocabularyDatabaseSchema = cdmSource$vocabDatabaseSchemaFinal
    )
  
  resolvedConceptSet[[i]] <- resolvedConceptSet[[i]] |> 
    dplyr::mutate(uniqueConceptSetId = uniqueConceptSets[i, ]$uniqueConceptSetId)
}

resolvedConceptSet <- dplyr::bind_rows(resolvedConceptSet)

saveRDS(object = resolvedConceptSet,
        file = file.path(outputFolder,
                         "resolvedConceptSet.RDS"))

