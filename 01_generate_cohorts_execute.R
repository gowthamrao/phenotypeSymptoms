filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))

PrivateScripts::executeCohortGenerationInParallel(
  cdmSources = cdmSources,
  outputFolder = file.path(rootFolder, "CohortGenerator"),
  cohortDefinitionSet = cohortDefinitionSet,
  cohortTableNames = CohortGenerator::getCohortTableNames(cohortTable = projectCode)
)

