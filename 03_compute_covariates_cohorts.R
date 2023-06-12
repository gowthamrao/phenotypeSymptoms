filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))


## loop over
primaryCohortIds <- cohortDefinitionSet |>
  dplyr::pull(subsetParent) |>
  sort() |> 
  unique()

for (i in (1:length(primaryCohortIds))) {
  primaryCohortId <- primaryCohortIds[[i]]
  targetCohortIds <- cohortDefinitionSet |>
    dplyr::filter(subsetParent == primaryCohortId) |>
    dplyr::pull(cohortId)
  covariateCohortIds <- cohortsToStudy |>
    dplyr::filter(targetCohortIds == primaryCohortId) |>
    dplyr::pull(featureCohortIds) |>
    unique()
  covariateCohortDefinitionSet <-
    PhenotypeLibrary::getPhenotypeLog()
  outputFolderByCohortId = file.path(rootFolder, "CovariateCohorts", primaryCohortId)
  # unlink(outputFolderByCohortId, recursive = TRUE, force = TRUE)
  dir.create(path = outputFolderByCohortId,
             showWarnings = FALSE,
             recursive = TRUE)
  PrivateScripts::executeCohortCovariateCharacterizationInParallel(
    cdmSources = cdmSources,
    databaseIds = databaseIds,
    targetCohortIds = targetCohortIds,
    covariateCohortIds = covariateCohortIds,
    unionCovariateCohorts = unionCovariateCohorts,
    targetCohortTableName = targetCohortTableName,
    cohortCovariateAnalysisId = 150,
    covariateCohortDefinitionSet = covariateCohortDefinitionSet,
    temporalStartDays = temporalStartDays,
    temporalEndDays = temporalEndDays,
    outputFolder = outputFolderByCohortId
  )
}
