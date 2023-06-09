
#########
conceptSets <- readRDS(file = file.path(outputFolder,
                                        "conceptSets.RDS"))

resolvedConceptToCohortXWalk <- resolvedConceptSet |> 
  dplyr::select(conceptId,
                uniqueConceptSetId) |>
  dplyr::distinct() |> 
  dplyr::inner_join(
    conceptSets |>
      dplyr::select(uniqueConceptSetId,
                    conceptSetUsedInEntryEvent,
                    cohortId) |> 
      dplyr::distinct()
  ) |> 
  dplyr::relocate(cohortId) |> 
  dplyr::arrange(cohortId,
                 conceptId) |> 
  dplyr::distinct()

targetCohortSymptomConceptId <- resolvedConceptToCohortXWalk |>
  dplyr::inner_join(
    cohortsToStudy |>
      dplyr::select(targetCohortIds,
                    featureCohortIds) |> 
      dplyr::rename(cohortId = featureCohortIds,
                    targetCohortId = targetCohortIds) |> 
      dplyr::distinct()
  ) |> 
  dplyr::select(targetCohortId,
                conceptId) |> 
  dplyr::distinct() |> 
  dplyr::arrange(targetCohortId,
                 conceptId)


targetCohortEntryConceptId <- resolvedConceptToCohortXWalk |>
  dplyr::filter(conceptSetUsedInEntryEvent == 1) |> 
  dplyr::inner_join(
    cohortsToStudy |>
      dplyr::select(targetCohortIds,
                    featureCohortIds) |> 
      dplyr::rename(cohortId = targetCohortIds) |> 
      dplyr::distinct()
  ) |> 
  dplyr::rename(targetCohortId = cohortId) |> 
  dplyr::select(targetCohortId,
                conceptId) |> 
  dplyr::distinct() |> 
  dplyr::arrange(targetCohortId,
                 conceptId)

presentInBoth <- targetCohortSymptomConceptId |> 
  dplyr::inner_join(targetCohortEntryConceptId) |> 
  dplyr::inner_join(
    cohortsToStudy |> 
      dplyr::select(targetCohortIds,
                    featureCohortIds) |> 
      dplyr::rename(targetCohortId = targetCohortIds,
                    featureCohortId = featureCohortIds)
  ) |> 
  dplyr::inner_join(
    resolvedConceptSet |> 
      dplyr::select(conceptId,
                    uniqueConceptSetId) |> 
      dplyr::inner_join(conceptSets |> 
                          dplyr::select(
                            cohortId,
                            uniqueConceptSetId
                          )) |> 
      dplyr::distinct() |> 
      dplyr::rename(featureCohortId = cohortId) |> 
      dplyr::select(featureCohortId,
                    conceptId) |> 
      dplyr::distinct()
  ) |> 
  dplyr::select(targetCohortId,
                featureCohortId,
                conceptId) |> 
  dplyr::arrange(targetCohortId,
                 featureCohortId,
                 conceptId) |> 
  dplyr::inner_join(
    resolvedConceptSet |> 
      dplyr::select(conceptId,
                    conceptName) |> 
      dplyr::distinct()
  ) |> 
  dplyr::inner_join(
    cohortsToResolve |> 
      dplyr::select(cohortId,
                    cohortName) |> 
      dplyr::rename(
        targetCohortId = cohortId,
        targetCohortName = cohortName
      )
  ) |> 
  dplyr::inner_join(
    cohortsToResolve |> 
      dplyr::select(cohortId,
                    cohortName) |> 
      dplyr::rename(
        featureCohortId = cohortId,
        featureCohortName = cohortName
      )
  ) |> 
  dplyr::select(dplyr::starts_with("target"),
                dplyr::starts_with("feature"),
                dplyr::starts_with("concept"))


connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = 'postgresql',
  server = paste(
    Sys.getenv("phenotypeLibraryServer"),
    Sys.getenv("phenotypeLibrarydb"),
    sep = "/"
  ),
  port = Sys.getenv("phenotypeLibraryDbPort"),
  user = Sys.getenv("phenotypeLibrarydbUser"),
  password = Sys.getenv("phenotypeLibrarydbPw")
)


conceptPrevalenceCount <-
  ConceptSetDiagnostics::getConceptPrevalenceCounts(
    connectionDetails = connectionDetails,
    conceptIds = targetCohortEntryConceptId$conceptId |>
      unique(),
    conceptPrevalenceSchema = "concept_prevalence"
  )

presentInBoth <- presentInBoth |> 
  dplyr::left_join(conceptPrevalenceCount)

saveRDS(object = presentInBoth,
        file = file.path(outputFolder,
                         "presentInBoth.RDS"))
readr::write_excel_csv(
  x = presentInBoth,
  file = "presentInBoth.csv",
  na = "",
  append = FALSE
)


View(presentInBoth |> 
       dplyr::filter(drc > 100))
