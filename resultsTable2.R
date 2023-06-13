# set up----
filePath <- dirname(rstudioapi::getActiveDocumentContext()$path)
source(file.path(filePath, "00_common.R"))
resultsFolder <- file.path(rootFolder,
                           "Report")
dir.create(path = resultsFolder,
           showWarnings = FALSE,
           recursive = TRUE)

meanThreshold <-  0.01
startDays <- c(0)
endDays <- c(0)

#connection
cdmSource <- PrivateScripts::getCdmSource(cdmSources = cdmSources)
connectionDetails <-
  PrivateScripts::createConnectionDetails(cdmSources = cdmSources)

#Information on datasources-----
databaseInformation <- cdmSources |>
  dplyr::filter(
    database %in% PrivateScripts::getListOfDatabaseIds(filterToUsData = TRUE, filterToClaims = TRUE)
  ) |>
  dplyr::select(sourceKey,
                databaseId,
                database,
                databaseDescription) |>
  dplyr::distinct() |>
  dplyr::rename(
    databaseName = databaseId,
    databaseId = sourceKey,
    databaseNameUnformatted = database
  )


# shared----
cohortDefinitionSet <- readRDS(file = file.path(filePath,
                                                "cohortDefinitionSet.RDS"))
conceptSets <- readRDS(file = file.path(rootFolder,
                                        "ConceptsResolved",
                                        "conceptSets.RDS"))
resolvedConceptSet <- readRDS(file = file.path(rootFolder,
                                               "ConceptsResolved",
                                               "resolvedConceptSet.RDS"))

conceptAncestor <-
  ConceptSetDiagnostics::getConceptAncestor(
    conceptIds = resolvedConceptSet$conceptId |> unique(),
    connectionDetails = connectionDetails,
    vocabularyDatabaseSchema = cdmSource$vocabDatabaseSchemaRhealth
  )
conceptDescendant <-
  ConceptSetDiagnostics::getConceptDescendant(
    conceptIds = resolvedConceptSet$conceptId |> unique(),
    connectionDetails = connectionDetails,
    vocabularyDatabaseSchema = cdmSource$vocabDatabaseSchemaRhealth
  )
conceptsRelatedInHierarchy <- dplyr::bind_rows(conceptAncestor,
                                               conceptDescendant) |>
  dplyr::select(ancestorConceptId,
                descendantConceptId) |>
  dplyr::collect()

targetFeatureCohortReference <- readRDS(file = file.path(filePath,
                                                         "cohortsToStudy.RDS")) |>
  dplyr::filter(targetCohortIds %in% targetCohortIds)





# target cohorts----
targetCohortIds <- c(
  27,
  33,
  68,
  70,
  71,
  72,
  74,
  220,
  234,
  238,
  248,
  249,
  251,
  258,
  284,
  292,
  329,
  356,
  362,
  366,
  367,
  372,
  395,
  396,
  407,
  410
)
removeNotAcute <- c(33, 238, 396)
otherRemove <- c(395, 407, 72, 220, 356, 366, 367, 372, 410)
targetCohortIds <- setdiff(x = targetCohortIds,
                           y = c(removeNotAcute,
                                 otherRemove))


# cohorts ----

featureExtractionOutputCompositeOuter <- c()

for (i in (1:length(targetCohortIds))) {
  targetCohortId <- targetCohortIds[[i]]
  print(targetCohortId)
  featureExtractionOutputCompositeInner <- c()
  for (j in (1:nrow(databaseInformation))) {
    databaseId <- databaseInformation[j,]$databaseId
    pathToRds <- file.path(rootFolder,
                           "CovariateConcepts",
                           databaseId,
                           "FeatureExtraction.RDS")
    
    if (file.exists(pathToRds)) {
      print(paste0("    ---", databaseId))
      featureExtractionData <- readRDS(file = pathToRds)
      
      featureExtractionOutputCompositeInner[[j]] <-
        PrivateScripts::createFeatureExtractionReport(
          cohortId = targetCohortId,
          cohortDefinitionSet = cohortDefinitionSet,
          characterization = featureExtractionData,
          meanThreshold = meanThreshold,
          startDays = startDays,
          endDays = endDays
        )
      
      conceptIdsInEntryEventCriteria <-
        resolvedConceptSet |>
        dplyr::inner_join(
          conceptSets |>
            dplyr::filter(
              conceptSetUsedInEntryEvent == 1,
              cohortId == !!targetCohortId
            ) |>
            dplyr::select(uniqueConceptSetId) |>
            dplyr::distinct(),
          by = "uniqueConceptSetId"
        ) |>
        dplyr::select(conceptId) |>
        dplyr::distinct()
      
      conceptIdsRelatedToConceptIdsInEntryEventCriteria <-
        dplyr::bind_rows(
          conceptsRelatedInHierarchy |>
            dplyr::filter(
              descendantConceptId %in% c(conceptIdsInEntryEventCriteria$conceptId |> unique())
            ) |>
            dplyr::select(ancestorConceptId) |>
            dplyr::rename(conceptId = ancestorConceptId),
          
          conceptsRelatedInHierarchy |>
            dplyr::filter(
              ancestorConceptId %in% c(conceptIdsInEntryEventCriteria$conceptId |> unique())
            ) |>
            dplyr::select(descendantConceptId) |>
            dplyr::rename(conceptId = descendantConceptId)
        ) |>
        dplyr::distinct()
      
      
      featureExtractionOutputCompositeInner[[j]] <-
        featureExtractionOutputCompositeInner[[j]] |>
        dplyr::filter(!conceptId %in% c(
          c(
            conceptIdsRelatedToConceptIdsInEntryEventCriteria$conceptId,
            conceptIdsInEntryEventCriteria$conceptId
          ) |> unique()
        )) |>
        dplyr::select(cohortId,
                      covariateName,
                      domainId,
                      analysisName,
                      sumValue,
                      mean) |>
        dplyr::mutate(databaseId = !!databaseId)
    }
  }
  featureExtractionOutputCompositeOuter[[i]] <-
    featureExtractionOutputCompositeInner |>
    dplyr::bind_rows()
}

dir.create(path = file.path(rootFolder,
                            "CovariateConcepts",
                            "Combined"))

featureExtractionOutputCompositeOuter <- featureExtractionOutputCompositeOuter |> 
  dplyr::bind_rows()

saveRDS(
  object = featureExtractionOutputCompositeOuter,
  file = file.path(
    rootFolder,
    "CovariateConcepts",
    "Combined",
    "notInEntryEvent.RDS"
  )
)

targetCohortIds
View(
  featureExtractionOutputCompositeOuter |>
    dplyr::filter(cohortId == 68) |>
    dplyr::inner_join(cohortDefinitionSet |>
                        dplyr::select(cohortId,
                                      cohortName)) |>
    dplyr::relocate(cohortName) |>
    dplyr::select(cohortName,
                  covariateName,
                  analysisName,
                  mean,
                  databaseId) |>
    tidyr::pivot_wider(
      id_cols = c(cohortName,
                  covariateName,
                  analysisName),
      names_from = databaseId,
      values_from = mean
    )
)
