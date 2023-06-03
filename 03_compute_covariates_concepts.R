filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
source(file.path(filePath, "01_selected_phenotypes.R"))
source(file.path(filePath, "02_generate_cohorts.R"))



outputFolder = file.path(rootFolder, "CovariateConcepts")
unlink(outputFolder, recursive = TRUE, force = TRUE)
dir.create(path = outputFolder,
           showWarnings = FALSE,
           recursive = TRUE)

temporalCovariateSettings <-
  FeatureExtraction::createTemporalCovariateSettings(
    useConditionEraGroupOverlap = TRUE,
    useConditionEraStart = TRUE, 
    useConditionEraOverlap = TRUE,
    useDemographicsAge = TRUE,
    useDemographicsAgeGroup = TRUE,
    useDemographicsGender = TRUE,
    useDemographicsIndexYear = TRUE,
    useDemographicsIndexYearMonth = TRUE,
    useDemographicsPostObservationTime = TRUE,
    useDemographicsPriorObservationTime = TRUE,
    useDemographicsIndexMonth = TRUE,
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
