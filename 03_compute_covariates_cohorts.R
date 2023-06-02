filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
source(file.path(filePath, "01_selected_phenotypes.R"))
source(file.path(filePath, "02_generate_cohorts.R"))


## loop over
primaryCohortIds <- cohortDefinitionSet |>
  dplyr::pull(subsetParent) |>
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
  outputFolderByCohortId = file.path(rootFolder, "CohortCovariates", primaryCohortId)
  unlink(outputFolderByCohortId, recursive = TRUE, force = TRUE)
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



# 
# 
# 
# 
# 
# 
# 
# featureExtractionOutput$covariates |>
#   dplyr::inner_join(featureExtractionOutput$timeRef) |>
#   dplyr::inner_join(featureExtractionOutput$covariateRef) |>
#   dplyr::inner_join(featureExtractionOutput$analysisRef) |>
#   dplyr::mutate(covariateCohortCohortId = (covariateId - analysisId) / 1000) |>
#   dplyr::filter(cohortId == cohortId) |>
#   dplyr::select(
#     cohortId,
#     startDay,
#     endDay,
#     covariateCohortCohortId,
#     conceptId,
#     analysisId,
#     covariateId,
#     cohortId,
#     covariateName,
#     analysisName,
#     domainId,
#     mean,
#     sumValue
#   ) |>
#   dplyr::filter(mean > 0.01) |>
#   dplyr::mutate(mean = round(x = mean, digits = 2)) |>
#   # dplyr::filter(analysisName == 'ConditionEraGroupOverlap') |>
#   dplyr::filter(startDay == 0) |>
#   dplyr::collect() |>
#   dplyr::arrange(dplyr::desc(mean)) |>
#   dplyr::filter(
#     covariateCohortCohortId %in% c(
#       cohortsToStudy |>
#         dplyr::filter(targetCohortIds == (cohortId - 1) / 1000) |>
#         dplyr::pull(featureCohortIds) |>
#         unique()
#     )
#   ) |>
#   View()
