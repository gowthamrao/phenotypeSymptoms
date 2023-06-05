filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
cohortsToStudy <- readRDS(file = file.path(filePath,
                                           "cohortsToStudy.RDS"))
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))
databaseIds <- PrivateScripts::getListOfDatabaseIds()


resultsFolder <- "D:\\studyResults\\symptomStudy\\CovariateCohorts\\Consolidated\\byPrimaryCohortId\\26"

characterization <- readFeatureExtractionOutput(inputFolder = resultsFolder)

createFeatureExtractionReport(characterization = characterization) |> 
  View()



