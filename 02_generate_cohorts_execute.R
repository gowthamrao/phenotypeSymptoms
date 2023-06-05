filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "02_generate_cohorts.R"))

PrivateScripts::executeCohortGenerationInParallel(
  cdmSources = cdmSources,
  outputFolder = file.path(rootFolder, "CohortGenerator"),
  cohortDefinitionSet = cohortDefinitionSet,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = projectCode)
)