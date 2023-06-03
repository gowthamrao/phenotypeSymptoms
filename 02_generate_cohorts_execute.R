PrivateScripts::executeCohortGenerationInParallel(
  cdmSources = cdmSources,
  outputFolder = file.path(rootFolder, "CohortGenerator"),
  cohortDefinitionSet = cohortDefinitionSet,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = projectCode)
)