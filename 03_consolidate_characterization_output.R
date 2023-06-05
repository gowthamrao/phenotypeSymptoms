filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))
databaseIds <- PrivateScripts::getListOfDatabaseIds()

debug(PrivateScripts::consolidateFeatureExtractionOutput)
## loop over
primaryCohortIds <- cohortDefinitionSet |>
  dplyr::pull(subsetParent) |>
  unique()
for (i in (1:length(primaryCohortIds))) {
  primaryCohortId <- primaryCohortIds[[i]]
  consolidateCharacterization <-
    PrivateScripts::consolidateFeatureExtractionOutput(
      inputFolder = file.path(rootFolder,
                              "CovariateCohorts",
                              primaryCohortId),
      groupName = "databaseId",
      outputFolder = file.path(
        rootFolder,
        "CovariateCohorts",
        "Consolidated",
        "byPrimaryCohortId",
        primaryCohortId
      )
    )
  
}
