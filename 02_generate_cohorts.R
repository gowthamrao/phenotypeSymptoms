filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
source(file.path(filePath, "01_selected_phenotypes.R"))

##########
firstEverWith365DaysPriorObservation <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr",
    definitionId = 1,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(priorTime = 365,
                                         limitTo = "firstEver")
    )
  )

startBeforeCalendarYear2016 <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr - start bf 2016",
    definitionId = 2,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarEndDate = '2015-12-31'
      )
    )
  )

startAfterCalendarYear2016 <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr start OAf 2016",
    definitionId = 3,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarStartDate = '2016-01-01'
      )
    )
  )

###############
firstEverWith365DaysPriorObservationMale <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr - M",
    definitionId = 11,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(priorTime = 365,
                                         limitTo = "firstEver"),
      CohortGenerator::createDemographicSubset(gender = c(8507))
    )
  )

startBeforeCalendarYear2016Male <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr - start bf 2016 - M",
    definitionId = 21,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarEndDate = '2015-12-31'
      ),
      CohortGenerator::createDemographicSubset(gender = c(8507))
    )
  )

startAfterCalendarYear2016Male <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr start OAf 2016 - M",
    definitionId = 31,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarStartDate = '2016-01-01'
      ),
      CohortGenerator::createDemographicSubset(gender = c(8507))
    )
  )

#################
#################
#################

firstEverWith365DaysPriorObservationFemale <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr - M",
    definitionId = 12,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(priorTime = 365,
                                         limitTo = "firstEver"),
      CohortGenerator::createDemographicSubset(gender = c(8532))
    )
  )

startBeforeCalendarYear2016Female <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr - start bf 2016 - M",
    definitionId = 22,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarEndDate = '2015-12-31'
      ),
      CohortGenerator::createDemographicSubset(gender = c(8532))
    )
  )

startAfterCalendarYear2016Female <-
  CohortGenerator::createCohortSubsetDefinition(
    name = "- 1st w 365d pr start OAf 2016 - M",
    definitionId = 32,
    subsetOperators = list(
      CohortGenerator::createLimitSubset(
        priorTime = 365,
        limitTo = "firstEver",
        calendarStartDate = '2016-01-01'
      ),
      CohortGenerator::createDemographicSubset(gender = c(8532))
    )
  )


cohortDefinitionSet <-
  PhenotypeLibrary::getPlCohortDefinitionSet(cohortIds = cohortsToStudy$targetCohortIds |> unique()) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = firstEverWith365DaysPriorObservation) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startBeforeCalendarYear2016) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startAfterCalendarYear2016) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = firstEverWith365DaysPriorObservationMale) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startBeforeCalendarYear2016Male) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startAfterCalendarYear2016Male) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = firstEverWith365DaysPriorObservationFemale) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startBeforeCalendarYear2016Female) |>
  CohortGenerator::addCohortSubsetDefinition(cohortSubsetDefintion = startAfterCalendarYear2016Female)

dir.create(path = rootFolder,
           showWarnings = FALSE, 
           recursive = TRUE)

saveRDS(object = cohortDefinitionSet,
        file = file.path(rootFolder, 
                         "cohortDefinitionSet.RDS"))

readr::write_excel_csv(
  x = cohortDefinitionSet,
  file = file.path(rootFolder,
                   "cohortDefinitionSet.csv"),
  na = "",
  append = FALSE
)

PrivateScripts::executeCohortGenerationInParallel(
  cdmSources = cdmSources,
  outputFolder = file.path(rootFolder, "CohortGenerator"),
  cohortDefinitionSet = cohortDefinitionSet,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = projectCode)
)
