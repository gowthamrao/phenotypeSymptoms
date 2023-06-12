# set up----
filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
resultsFolder <- file.path(rootFolder,
                           "Report")
dir.create(path = resultsFolder,
           showWarnings = FALSE,
           recursive = TRUE)

#Information on datasources-----
databaseInformation <- cdmSources |>
  dplyr::filter(
    database %in% PrivateScripts::getListOfDatabaseIds(filterToUsData = TRUE, filterToClaims = TRUE)
  ) |>
  dplyr::select(sourceKey,
                databaseId,
                database,
                databaseDescription) |>
  dplyr::distinct() |>
  dplyr::rename(
    databaseName = databaseId,
    databaseId = sourceKey,
    databaseNameUnformatted = database
  )


# shared----
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))
conceptSets <- readRDS(file = file.path(rootFolder,
                                        "ConceptsResolved",
                                        "conceptSets.RDS"))
resolvedConceptSet <- readRDS(file = file.path(rootFolder,
                                               "ConceptsResolved",
                                               "resolvedConceptSet.RDS"))

targetFeatureCohortReference <- readRDS(file = file.path(filePath,
                                                         "cohortsToStudy.RDS")) |>
  dplyr::filter(targetCohortIds %in% targetCohortIds)





# target cohorts----
targetCohortIds <- c(
  27,
  33,
  68,
  70,
  71,
  72,
  74,
  220,
  234,
  238,
  248,
  249,
  251,
  258,
  284,
  292,
  329,
  356,
  362,
  366,
  367,
  372,
  395,
  396,
  407,
  410
)
removeNotAcute <- c(33, 238, 396)
otherRemove <- c(395, 407, 72, 220, 356, 366, 367, 372, 410)
targetCohortIds <- setdiff(x = targetCohortIds,
                           y = c(removeNotAcute,
                                 otherRemove))


# cohorts ----
featureExtractionOutputComposite <- c()
for (i in (1:length(targetCohortIds))) {
  targetCohortId <- targetCohortIds[[i]]
  for (j in (1:length(databaseInformation))) {
    databaseId <- databaseInformation[j, ]$databaseId
    pathToRds <- file.path(rootFolder,
                           "CovariateConcepts",
                           databaseId,
                           "FeatureExtraction.RDS")
    if (file.exists(pathToRds)) {
      featureExtractionData <- readRDS(file = pathToRds)
      
      featureExtractionOutputComposite[[i]] <-
        PrivateScripts::createFeatureExtractionReport(
          cohortId = 27,
          cohortDefinitionSet = cohortDefinitionSet,
          characterization = featureExtractionData,
          meanThreshold = 0.01,
          startDays = c(0),
          endDays = c(0)
        ) |>
        dplyr::anti_join(
          resolvedConceptSet |>
            dplyr::inner_join(
              conceptSets |>
                dplyr::filter(
                  conceptSetUsedInEntryEvent == 1,
                  cohortId == !!targetCohortId
                ) |>
                dplyr::select(uniqueConceptSetId) |>
                dplyr::distinct(),
              by = "uniqueConceptSetId"
            ) |>
            dplyr::select(conceptId) |>
            dplyr::distinct(),
          by = "conceptId"
        ) |>
        dplyr::select(cohortId,
                      covariateName,
                      domainId,
                      analysisName,
                      sumValue,
                      mean) |>
        dplyr::mutate(databaseId = !!databaseId)
    }
  }
}
