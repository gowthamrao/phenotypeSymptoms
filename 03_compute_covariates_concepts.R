filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
source(file.path(filePath, "01_selected_phenotypes.R"))
source(file.path(filePath, "02_generate_cohorts.R"))



outputFolder = file.path(rootFolder, "ObsConceptCovariates")
unlink(outputFolder, recursive = TRUE, force = TRUE)
dir.create(path = outputFolder,
           showWarnings = FALSE,
           recursive = TRUE)

temporalCovariateSettings <-
  FeatureExtraction::createTemporalCovariateSettings(
    useObservation = TRUE,
    temporalStartDays = temporalStartDays,
    temporalEndDays = temporalEndDays
  )

PrivateScripts::executeConceptCovariateCharacterizationInParallel(
  cdmSources = cdmSources,
  databaseIds = databaseIds,
  temporalCovariateSettings = temporalCovariateSettings,
  targetCohortIds = cohortDefinitionSet$cohortId |> unique(),
  targetCohortTableName = targetCohortTableName,
  outputFolder = outputFolder
)
