filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))



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
    useVisitCount = TRUE,
    useVisitConceptCount = TRUE,
    useCareSiteId = TRUE,
    useConditionOccurrencePrimaryInpatient = TRUE,
    useConditionOccurrence = TRUE,
    useDrugEraStart = TRUE,
    useDrugEraOverlap = TRUE,
    useDistinctConditionCount = TRUE,
    useDistinctIngredientCount = TRUE,
    useDrugEraGroupOverlap = TRUE,
    useDrugEraGroupStart = TRUE,
    useProcedureOccurrence = TRUE,
    useMeasurement = TRUE,
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
